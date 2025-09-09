<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
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
<#include "../procedures.java.ftl">
<#include "../mcitems.ftl">
<#include "../triggers.java.ftl">
package ${package}.item;
<#assign hasCustomJAVAModels = data.hasCustomJAVAModel() || data.getModels()?filter(e -> e.hasCustomJAVAModel())?has_content>

<#compress>
public class ${name}Item extends <#if data.hasBannerPatterns()>BannerPattern<#elseif data.isMusicDisc>MusicDisc</#if>Item {

	public ${name}Item() {
    super(<#if data.hasBannerPatterns()>null,
                <#elseif data.isMusicDisc>
                ${data.musicDiscAnalogOutput}, () -> ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.musicDiscMusic}")),
                </#if>new Item.Properties()
				.group(<@CreativeTabs data.creativeTabs/>)
				<#if data.hasInventory()>
				.maxStackSize(1)
				<#elseif data.damageCount != 0>
				.maxDamage(${data.damageCount})
				<#elseif data.stackSize != 64>
				.maxStackSize(${data.stackSize})
				</#if>
				<#if data.immuneToFire>
				.isImmuneToFire()
				</#if>
				<#if data.rarity != "COMMON">
				.rarity(Rarity.${data.rarity})
				</#if>
				<#if data.isFood>
				.food((new Food.Builder())
					.hunger(${data.nutritionalValue})
					.saturation(${data.saturation}f)
					<#if data.isAlwaysEdible>.setAlwaysEdible()</#if>
					<#if data.isMeat>.meat()</#if>
					.build())
				</#if>
				<#if data.stayInGridWhenCrafting && (!data.recipeRemainder?? || data.recipeRemainder.isEmpty()) && data.damageCount != 0>
				.setNoRepair()
				</#if>
				<#if hasCustomJAVAModels>
				.setISTER(() -> new Callable() {
			        private ${name}ItemRenderer rendererInstance;

			        @Override public ItemStackTileEntityRenderer call() throws Exception {
				        if (rendererInstance == null)
					        rendererInstance = new ${name}ItemRenderer();
				        return rendererInstance;
			        }
                })
	            </#if>
		);
	}

	<#if data.hasBannerPatterns()> <#-- Workaround to allow both music disc and patterns info in description -->
	@Override @OnlyIn(Dist.CLIENT) public IFormattableTextComponent func_219981_d_() {
		return new TranslationTextComponent(this.getTranslationKey() + ".patterns");
	}
	</#if>

	<#if data.hasNonDefaultAnimation()>
	@Override public UseAction getUseAction(ItemStack itemstack) {
		return UseAction.${data.animation?upper_case};
	}
	</#if>

        <#if data.isFood && (data.animation == "drink")>
        @Override public SoundEvent getEatSound() {
            return SoundEvents.ENTITY_GENERIC_DRINK;
        }
        </#if>

	<#if data.stayInGridWhenCrafting>
		@Override public boolean hasContainerItem() {
			return true;
		}

		<#if data.recipeRemainder?? && !data.recipeRemainder.isEmpty()>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				return ${mappedMCItemToItemStackCode(data.recipeRemainder, 1)};
			}
		<#elseif data.damageOnCrafting && data.damageCount != 0>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				ItemStack retval = new ItemStack(this);
				retval.setDamage(itemstack.getDamage() + 1);
				if(retval.getDamage() >= retval.getMaxDamage()) {
					return ItemStack.EMPTY;
				}
				return retval;
			}
		<#else>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				return new ItemStack(this);
			}
		</#if>
	</#if>

	<#if data.enchantability != 0>
	@Override public int getItemEnchantability() {
		return ${data.enchantability};
	}
	</#if>

	<#if (!data.isFood && data.useDuration != 0) || (data.isFood && data.useDuration != 32)>
	@Override public int getUseDuration(ItemStack itemstack) {
		return ${data.useDuration};
	}
	</#if>

	<#if data.toolType != 1>
	@Override public float getDestroySpeed(ItemStack par1ItemStack, BlockState par2Block) {
		return ${data.toolType}f;
	}
	</#if>

	<#if data.enableMeleeDamage>
		@Override public Multimap<Attribute, AttributeModifier> getAttributeModifiers(EquipmentSlotType equipmentSlot) {
			if (equipmentSlot == EquipmentSlotType.MAINHAND) {
				ImmutableMultimap.Builder<Attribute, AttributeModifier> builder = ImmutableMultimap.builder();
				builder.putAll(super.getAttributeModifiers(equipmentSlot));
				builder.put(Attributes.ATTACK_DAMAGE, new AttributeModifier(ATTACK_DAMAGE_MODIFIER, "Item modifier", ${data.damageVsEntity - 1}d, AttributeModifier.Operation.ADDITION));
				builder.put(Attributes.ATTACK_SPEED, new AttributeModifier(ATTACK_SPEED_MODIFIER, "Item modifier", -2.4, AttributeModifier.Operation.ADDITION));
				return builder.build();
			}
			return super.getAttributeModifiers(equipmentSlot);
		}
	</#if>

	<@hasGlow data.glowCondition/>

	<#if data.destroyAnyBlock>
	@Override public boolean canHarvestBlock(BlockState state) {
		return true;
	}
	</#if>

	<@addSpecialInformation data.specialInformation, "item." + modid + "." + registryname/>

	<#assign shouldExplicitlyCallStartUsing = !data.isFood && (data.useDuration > 0)> <#-- ranged items handled in if below so no need to check for that here too -->
	<#if hasProcedure(data.onRightClickedInAir) || data.hasInventory() || data.enableRanged || shouldExplicitlyCallStartUsing>
	@Override public ActionResult<ItemStack> onItemRightClick(World world, PlayerEntity entity, Hand hand) {
		<#if data.enableRanged>
		ActionResult<ItemStack> ar = ActionResult.resultFail(entity.getHeldItem(hand));
		<#else>
		ActionResult<ItemStack> ar = super.onItemRightClick(world, entity, hand);
		</#if>

		<#if data.enableRanged>
			<#if hasProcedure(data.rangedUseCondition)>
			if (<@procedureCode data.rangedUseCondition, {
				"x": "entity.getPosX()",
				"y": "entity.getPosY()",
				"z": "entity.getPosZ()",
				"world": "world",
				"entity": "entity",
				"itemstack": "ar.getResult()"
			}, false/>)
			</#if>
			if (entity.abilities.isCreativeMode || findAmmo(entity) != ItemStack.EMPTY) {
				ar = ActionResult.resultSuccess(entity.getHeldItem(hand));
				entity.setActiveHand(hand);
			}
		<#elseif shouldExplicitlyCallStartUsing>
			entity.setActiveHand(hand);
		</#if>

		<#if data.hasInventory()>
		if(entity instanceof ServerPlayerEntity) {
			NetworkHooks.openGui((ServerPlayerEntity) entity, new INamedContainerProvider() {
				@Override public ITextComponent getDisplayName() {
					return new StringTextComponent("${data.name}");
				}

				@Override public Container createMenu(int id, PlayerInventory inventory, PlayerEntity player) {
					PacketBuffer packetBuffer = new PacketBuffer(Unpooled.buffer());
					packetBuffer.writeBlockPos(entity.getPosition());
					packetBuffer.writeByte(hand == Hand.MAIN_HAND ? 0 : 1);
					return new ${data.guiBoundTo}Menu(id, inventory, packetBuffer);
				}
			}, buf -> {
				buf.writeBlockPos(entity.getPosition());
				buf.writeByte(hand == Hand.MAIN_HAND ? 0 : 1);
			});
		}
		</#if>

		<#if hasProcedure(data.onRightClickedInAir)>
			<@procedureCode data.onRightClickedInAir, {
				"x": "entity.getPosX()",
				"y": "entity.getPosY()",
				"z": "entity.getPosZ()",
				"world": "world",
				"entity": "entity",
				"itemstack": "ar.getResult()"
			}/>
		</#if>
		return ar;
	}
	</#if>

	<#if hasProcedure(data.onFinishUsingItem) || data.hasEatResultItem()>
		@Override public ItemStack onItemUseFinish(ItemStack itemstack, World world, LivingEntity entity) {
			ItemStack retval =
				<#if data.hasEatResultItem()>
					${mappedMCItemToItemStackCode(data.eatResultItem, 1)};
				</#if>
			super.onItemUseFinish(itemstack, world, entity);

			<#if hasProcedure(data.onFinishUsingItem)>
				double x = entity.getPosX();
				double y = entity.getPosY();
				double z = entity.getPosZ();
				<@procedureOBJToCode data.onFinishUsingItem/>
			</#if>

			<#if data.hasEatResultItem()>
				if (itemstack.isEmpty()) {
					return retval;
				} else {
					if (entity instanceof PlayerEntity && !((PlayerEntity) entity).abilities.isCreativeMode) {
						if (!((PlayerEntity) entity).inventory.addItemStackToInventory(retval))
							((PlayerEntity) entity).dropItem(retval, false);
					}
					return itemstack;
				}
			<#else>
				return retval;
			</#if>
		}
	</#if>

	<@onItemUsedOnBlock data.onRightClickedOnBlock/>

	<@onEntityHitWith data.onEntityHitWith, (data.damageCount != 0 && data.enableMeleeDamage), 1/>

	<@onEntitySwing data.onEntitySwing/>

	<@onCrafted data.onCrafted/>

	<@onItemTick data.onItemInUseTick, data.onItemInInventoryTick/>

	<@onDroppedByPlayer data.onDroppedByPlayer/>

	<#if data.hasInventory()>
	@Override public ICapabilityProvider initCapabilities(ItemStack stack, @Nullable CompoundNBT compound) {
		return new ${name}InventoryCapability();
	}

	@Override public CompoundNBT getShareTag(ItemStack stack) {
		CompoundNBT nbt = stack.getOrCreateTag();
		stack.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null).ifPresent(capability -> nbt.put("Inventory", ((ItemStackHandler) capability).serializeNBT()));
		return nbt;
	}

	@Override public void readShareTag(ItemStack stack, @Nullable CompoundNBT nbt) {
		super.readShareTag(stack, nbt);
		if(nbt != null)
			stack.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null).ifPresent(capability -> ((ItemStackHandler) capability).deserializeNBT((CompoundNBT) nbt.get("Inventory")));
	}
	</#if>

	<#if hasProcedure(data.onStoppedUsing) || (data.enableRanged && !data.shootConstantly)>
		@Override public void onPlayerStoppedUsing(ItemStack itemstack, World world, LivingEntity entity, int time) {
			<#if hasProcedure(data.onStoppedUsing)>
				<@procedureCode data.onStoppedUsing, {
					"x": "entity.getPosX()",
					"y": "entity.getPosY()",
					"z": "entity.getPosZ()",
					"world": "world",
					"entity": "entity",
					"itemstack": "itemstack",
					"time": "time"
				}/>
			</#if>
			<#if data.enableRanged && !data.shootConstantly>
				if (!world.isRemote() && entity instanceof ServerPlayerEntity) {
					<#if data.rangedItemChargesPower>
						float pullingPower = BowItem.getArrowVelocity(this.getUseDuration(itemstack) - time);
						if (pullingPower < 0.1)
							return;
					</#if>
					<@arrowShootCode/>
				}
			</#if>
		}
	</#if>

	<#if data.enableRanged && data.shootConstantly>
		@Override public void onUsingTick(ItemStack itemstack, LivingEntity entity, int count) {
			World world = entity.world;
			if (!world.isRemote() && entity instanceof ServerPlayerEntity) {
				<@arrowShootCode/>
				entity.stopActiveHand();
			}
		}
	</#if>

	<#if data.enableRanged>
	private ItemStack findAmmo(PlayerEntity player) {
		<#if data.projectileDisableAmmoCheck>
		return new ItemStack(${generator.map(data.projectile.getUnmappedValue(), "projectiles", 2)});
		<#else>
		ItemStack stack = ShootableItem.getHeldAmmo(player, e -> e.getItem() == ${generator.map(data.projectile.getUnmappedValue(), "projectiles", 2)});
		if(stack == ItemStack.EMPTY) {
			for (int i = 0; i < player.inventory.mainInventory.size(); i++) {
				ItemStack teststack = player.inventory.mainInventory.get(i);
				if(teststack != null && teststack.getItem() == ${generator.map(data.projectile.getUnmappedValue(), "projectiles", 2)}) {
					stack = teststack;
					break;
				}
			}
		}
		return stack;
		</#if>
	}
	</#if>
}

<#macro arrowShootCode>
	<#assign projectile = data.projectile.getUnmappedValue()>
	ItemStack stack = findAmmo((ServerPlayerEntity) entity);
	if (((ServerPlayerEntity) entity).abilities.isCreativeMode || stack != ItemStack.EMPTY) {
		<#assign projectileClass = generator.map(projectile, "projectiles", 0)>
		<#if projectile.startsWith("CUSTOM:")>
			${projectileClass} projectile = ${projectileClass}.shoot(world, entity, world.getRandom()<#if data.rangedItemChargesPower>, pullingPower</#if>);
		<#elseif projectile.endsWith("Arrow")>
			${projectileClass} projectile = new ${projectileClass}(world, entity);
			projectile.func_234612_a_(entity, entity.rotationPitch, entity.rotationYaw, 0, <#if data.rangedItemChargesPower>pullingPower * </#if>3.15f, 1.0F);
			world.addEntity(projectile);
			world.playSound(null, entity.getPosX(), entity.getPosY(), entity.getPosZ(), ForgeRegistries.SOUND_EVENTS
				.getValue(new ResourceLocation("entity.arrow.shoot")), SoundCategory.PLAYERS, 1, 1f / (world.getRandom().nextFloat() * 0.5f + 1));
		</#if>

		<#if data.damageCount != 0>
		itemstack.damageItem(1, entity, e -> e.sendBreakAnimation(entity.getActiveHand()));
		</#if>

		if (((ServerPlayerEntity) entity).abilities.isCreativeMode) {
			projectile.pickupStatus = AbstractArrowEntity.PickupStatus.CREATIVE_ONLY;
		} else {
			if (stack.isDamageable()) {
				if (stack.attemptDamageItem(1, world.getRandom(), (ServerPlayerEntity) entity)) {
					stack.shrink(1);
					stack.setDamage(0);
					if (stack.isEmpty())
						((ServerPlayerEntity) entity).inventory.deleteStack(stack);
				}
			} else {
				stack.shrink(1);
				if (stack.isEmpty())
				   ((ServerPlayerEntity) entity).inventory.deleteStack(stack);
			}
		}

		<#if hasProcedure(data.onRangedItemUsed)>
			<@procedureCode data.onRangedItemUsed, {
				"x": "entity.getPosX()",
				"y": "entity.getPosY()",
				"z": "entity.getPosZ()",
				"world": "world",
				"entity": "entity",
				"itemstack": "itemstack"
			}/>
		</#if>
	}
</#macro>
</#compress>
<#-- @formatter:on -->
