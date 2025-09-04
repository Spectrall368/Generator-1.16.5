<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2022, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
<#assign slotnum = 0>
package ${package}.world.inventory;

import ${package}.${JavaModName};

<#compress>
<#if hasProcedure(data.onTick)>
@Mod.EventBusSubscriber
</#if>
public class ${name}Menu extends Container implements ${JavaModName}Menus.MenuAccessor {

	public final Map<String, Object> menuState = new HashMap<String, Object>() {
		@Override public Object put(String key, Object value) {
			<#-- Prevent arbitrary data storage beyond the menu state -->
			if (!this.containsKey(key) && this.size() >= ${data.components?size}) return null;
			return super.put(key, value);
		}
	};

	public final World world;
	public final PlayerEntity entity;
	public int x, y, z;
	private IWorldPosCallable access = IWorldPosCallable.DUMMY;

	private IItemHandler internal;

	private final Map<Integer, Slot> customSlots = new HashMap<>();

	private boolean bound = false;
	private Supplier<Boolean> boundItemMatcher = null;
	private Entity boundEntity = null;
	private TileEntity boundBlockEntity = null;

	public ${name}Menu(int id, PlayerInventory inv, PacketBuffer extraData) {
		super(${JavaModName}Menus.${REGISTRYNAME}.get(), id);

		this.entity = inv.player;
		this.world = inv.player.world;

		this.internal = new ItemStackHandler(${data.getMaxSlotID() + 1});

		BlockPos pos = null;
		if (extraData != null) {
			pos = extraData.readBlockPos();
			this.x = pos.getX();
			this.y = pos.getY();
			this.z = pos.getZ();
			access = IWorldPosCallable.of(world, pos);
		}

		<#if data.type == 1>
			if (pos != null) {
				if (extraData.readableBytes() == 1) { // bound to item
					byte hand = extraData.readByte();
					ItemStack itemstack = hand == 0 ? this.entity.getHeldItemMainhand() : this.entity.getHeldItemOffhand();
					this.boundItemMatcher = () -> itemstack == (hand == 0 ? this.entity.getHeldItemMainhand() : this.entity.getHeldItemOffhand());
					itemstack.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null).ifPresent(capability -> {
						this.internal = capability;
						this.bound = true;
					});
				} else if (extraData.readableBytes() > 1) { // bound to entity
					extraData.readByte(); // drop padding
					boundEntity = world.getEntityByID(extraData.readVarInt());
					if(boundEntity != null)
						boundEntity.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null).ifPresent(capability -> {
							this.internal = capability;
							this.bound = true;
						});
				} else { // might be bound to block
					boundBlockEntity = this.world.getTileEntity(pos);
					if (boundBlockEntity != null)
						boundBlockEntity.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null).ifPresent(capability -> {
							this.internal = capability;
							this.bound = true;
						});
				}
			}

			<#list data.components as component>
				<#if component.getClass().getSimpleName()?ends_with("Slot")>
					<#assign slotnum += 1>
					this.customSlots.put(${component.id}, this.addSlot(new SlotItemHandler(internal, ${component.id},
						${component.gx(data.width) + 1},
						${component.gy(data.height) + 1}) {
						private final int slot = ${component.id}; <#-- #5209, this is needed for procedure dependencies -->
						private int x = ${name}Menu.this.x; <#-- #5239 - x and y provided by slot are in-GUI, not in-world coordinates -->
 						private int y = ${name}Menu.this.y;

						<#if hasProcedure(component.disablePickup) || component.disablePickup.getFixedValue()>
						@Override public boolean canTakeStack(PlayerEntity entity) {
							return <@procedureOBJToConditionCode component.disablePickup false true/>;
						}
						</#if>

						<#if hasProcedure(component.onSlotChanged)>
						@Override public void onSlotChanged() {
							super.onSlotChanged();
							slotChanged(${component.id}, 0, 0);
						}
						</#if>

						<#if hasProcedure(component.onTakenFromSlot)>
						@Override public ItemStack onTake(PlayerEntity entity, ItemStack stack) {
							slotChanged(${component.id}, 1, stack.getCount());
							return super.onTake(entity, stack);
						}
						</#if>

						<#if hasProcedure(component.onStackTransfer)>
						@Override public void onSlotChange(ItemStack a, ItemStack b) {
							super.onSlotChange(a, b);
							slotChanged(${component.id}, 2, b.getCount() - a.getCount());
						}
						</#if>

						<#if component.getClass().getSimpleName() == "InputSlot">
							<#if hasProcedure(component.disablePlacement) || component.disablePlacement.getFixedValue()>
								@Override public boolean isItemValid(ItemStack itemstack) {
									return <@procedureOBJToConditionCode component.disablePlacement false true/>;
								}
							<#elseif component.inputLimit.toString()?has_content>
								@Override public boolean isItemValid(ItemStack stack) {
									<#if component.inputLimit.getUnmappedValue().startsWith("TAG:")>
										<#assign tag = "\"" + component.inputLimit.getUnmappedValue().replace("TAG:", "").replace("mod:", modid + ":") + "\"">
										return stack.getItem().isIn(ItemTags.createOptional(new ResourceLocation(${tag})));
									<#else>
										return ${mappedMCItemToItem(component.inputLimit)} == stack.getItem();
									</#if>
								}
							</#if>
						<#elseif component.getClass().getSimpleName() == "OutputSlot">
							@Override public boolean isItemValid(ItemStack stack) {
								return false;
							}
						</#if>
					}));
				</#if>
			</#list>

			<#assign coffx = data.getInventorySlotsX()>
			<#assign coffy = data.getInventorySlotsY()>

			for (int si = 0; si < 3; ++si)
				for (int sj = 0; sj < 9; ++sj)
					this.addSlot(new Slot(inv, sj + (si + 1) * 9, ${coffx} + 8 + sj * 18, ${coffy} + 84 + si * 18));

			for (int si = 0; si < 9; ++si)
				this.addSlot(new Slot(inv, si, ${coffx} + 8 + si * 18, ${coffy} + 142));
		</#if>

		<#if hasProcedure(data.onOpen)>
			<@procedureOBJToCode data.onOpen/>
		</#if>
	}

	@Override public boolean canInteractWith(PlayerEntity player) {
		if (this.bound) {
			if (this.boundItemMatcher != null)
				return this.boundItemMatcher.get();
			else if (this.boundBlockEntity != null)
				return Container.isWithinUsableDistance(this.access, player, this.boundBlockEntity.getBlockState().getBlock());
			else if (this.boundEntity != null)
				return this.boundEntity.isAlive();
		}
		return true;
	}

	<#if data.type == 1>
		@Override public ItemStack transferStackInSlot(PlayerEntity playerIn, int index) {
			ItemStack itemstack = ItemStack.EMPTY;
			Slot slot = (Slot) this.inventorySlots.get(index);

			if (slot != null && slot.getHasStack()) {
				ItemStack itemstack1 = slot.getStack();
				itemstack = itemstack1.copy();

				if (index < ${slotnum}) {
					if (!this.mergeItemStack(itemstack1, ${slotnum}, this.inventorySlots.size(), true))
						return ItemStack.EMPTY;
					slot.onSlotChange(itemstack1, itemstack);
				} else if (!this.mergeItemStack(itemstack1, 0, ${slotnum}, false)) {
					if (index < ${slotnum} + 27) {
						if (!this.mergeItemStack(itemstack1, ${slotnum} + 27, this.inventorySlots.size(), true))
							return ItemStack.EMPTY;
					} else {
						if (!this.mergeItemStack(itemstack1, ${slotnum}, ${slotnum} + 27, false))
							return ItemStack.EMPTY;
					}
					return ItemStack.EMPTY;
				}

				if (itemstack1.isEmpty()) {
					slot.putStack(ItemStack.EMPTY);
				} else {
					slot.onSlotChanged();
				}

				if (itemstack1.getCount() == itemstack.getCount()) {
					return ItemStack.EMPTY;
				}

				slot.onTake(playerIn, itemstack1);
			}
			return itemstack;
		}

		<#-- #47997 -->
		@Override ${mcc.getMethod("net.minecraft.inventory.container.Container", "mergeItemStack", "ItemStack", "int", "int", "boolean")
			.replace("slot.onSlotChanged();", "slot.putStack(itemstack);")
			.replace("!itemstack.isEmpty()", "slot.isItemValid(itemstack) && !itemstack.isEmpty()")}

		@Override public void onContainerClosed(PlayerEntity playerIn) {
			super.onContainerClosed(playerIn);

			<#if hasProcedure(data.onClosed)>
				<@procedureOBJToCode data.onClosed/>
			</#if>

			if (!bound && playerIn instanceof ServerPlayerEntity) {
				if (!((ServerPlayerEntity) playerIn).isAlive() || ((ServerPlayerEntity) playerIn).hasDisconnected()) {
					for(int j = 0; j < internal.getSlots(); ++j) {
						<#list data.components as component>
							<#if component.getClass().getSimpleName()?ends_with("Slot") && !component.dropItemsWhenNotBound>
								if(j == ${component.id}) continue;
							</#if>
						</#list>
						playerIn.dropItem(internal.getStackInSlot(j), false);
						if (internal instanceof IItemHandlerModifiable)
							((IItemHandlerModifiable) internal).setStackInSlot(j, ItemStack.EMPTY);
					}
				} else {
					for(int i = 0; i < internal.getSlots(); ++i) {
						<#list data.components as component>
							<#if component.getClass().getSimpleName()?ends_with("Slot") && !component.dropItemsWhenNotBound>
								if(i == ${component.id}) continue;
							</#if>
						</#list>
						playerIn.inventory.placeItemBackInInventory(playerIn.world, internal.getStackInSlot(i));
						if (internal instanceof IItemHandlerModifiable)
							((IItemHandlerModifiable) internal).setStackInSlot(i, ItemStack.EMPTY);
					}
				}
			}
		}

		<#if data.hasSlotEvents()>
			private void slotChanged(int slotid, int ctype, int meta) {
				if(this.world != null && this.world.isRemote()) {
					${JavaModName}.PACKET_HANDLER.sendToServer(new ${name}SlotMessage(slotid, x, y, z, ctype, meta));
					${name}SlotMessage.handleSlotAction(entity, slotid, ctype, meta, x, y, z);
				}
			}
		</#if>
	<#else>
		@Override public ItemStack transferStackInSlot(PlayerEntity playerIn, int index) {
			return ItemStack.EMPTY;
		}
		<#if hasProcedure(data.onClosed)>
			@Override public void onContainerClosed(PlayerEntity playerIn) {
				super.onContainerClosed(playerIn);
				<@procedureOBJToCode data.onClosed/>
			}
		</#if>
	</#if>

	@Override public Map<Integer, Slot> getSlots() {
		return Collections.unmodifiableMap(customSlots);
	}

	@Override public Map<String, Object> getMenuState() {
		return menuState;
	}

	<#if hasProcedure(data.onTick)>
		@SubscribeEvent public static void onPlayerTick(TickEvent.PlayerTickEvent event) {
			PlayerEntity entity = event.player;
			if(event.phase == TickEvent.Phase.END && entity.openContainer instanceof ${name}Menu) {
				World world = ((${name}Menu) entity.openContainer).world;
				double x = ((${name}Menu) entity.openContainer).x;
				double y = ((${name}Menu) entity.openContainer).y;
				double z = ((${name}Menu) entity.openContainer).z;
				<@procedureOBJToCode data.onTick/>
			}
		}
	</#if>
}
</#compress>
<#-- @formatter:on -->
