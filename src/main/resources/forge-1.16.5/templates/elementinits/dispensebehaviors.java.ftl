<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
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

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<#assign itemextensions = w.getGElementsOfType("itemextension")?filter(e -> e.hasDispenseBehavior)>
<#assign specialentities = w.getGElementsOfType("specialentity")>

<@javacompress>
@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public class ${JavaModName}DispenseBehaviors {

	@SubscribeEvent public static void init(FMLCommonSetupEvent event) {
		event.enqueueWork(() -> {
			<#list itemextensions as extension>
			DispenserBlock.registerDispenseBehavior(${mappedMCItemToItem(extension.item)},
			<#if hasProcedure(extension.dispenseSuccessCondition)>
			new OptionalDispenseBehavior() {
				public ItemStack dispenseStack(IBlockSource blockSource, ItemStack stack) {
					ItemStack itemstack = stack.copy();
					World world = blockSource.getWorld();
					Direction direction = blockSource.getBlockState().get(DispenserBlock.FACING);
					int x = blockSource.getBlockPos().getX();
					int y = blockSource.getBlockPos().getY();
					int z = blockSource.getBlockPos().getZ();

					this.setSuccessful(<@procedureOBJToConditionCode extension.dispenseSuccessCondition/>);

					<#if hasProcedure(extension.dispenseResultItemstack)>
						boolean success = this.isSuccessful();
						<#if hasReturnValueOf(extension.dispenseResultItemstack, "itemstack")>
							return <@procedureOBJToItemstackCode extension.dispenseResultItemstack, false/>;
						<#else>
							<@procedureOBJToCode extension.dispenseResultItemstack/>
							if (success) {
								itemstack.shrink(1);
							}
							return itemstack;
						</#if>
					<#else>
						if (this.isSuccessful()) {
							itemstack.shrink(1);
						}
						return itemstack;
					</#if>
				}
			}
			<#else>
			new DefaultDispenseItemBehavior() {
				public ItemStack dispenseStack(IBlockSource blockSource, ItemStack itemstack) {
					<#if hasProcedure(extension.dispenseResultItemstack)>
						<#if hasReturnValueOf(extension.dispenseResultItemstack, "itemstack")>
							return <@procedureCode extension.dispenseResultItemstack, {
								"x": "blockSource.getBlockPos().getX()",
								"y": "blockSource.getBlockPos().getY()",
								"z": "blockSource.getBlockPos().getZ()",
								"itemstack": "itemstack.copy()",
								"world": "blockSource.getWorld()",
								"direction": "blockSource.getBlockState().get(DispenserBlock.FACING)",
								"success": "true" <#-- Dispense success condition defaults to true if not specified -->
							}, false/>;
						<#else>
							<@procedureCode extension.dispenseResultItemstack, {
								"x": "blockSource.getBlockPos().getX()",
								"y": "blockSource.getBlockPos().getY()",
								"z": "blockSource.getBlockPos().getZ()",
								"itemstack": "itemstack.copy()",
								"world": "blockSource.getWorld()",
								"direction": "blockSource.getBlockState().get(DispenserBlock.FACING)",
								"success": "true" <#-- Dispense success condition defaults to true if not specified -->
							}/>
							itemstack.shrink(1);
							return itemstack;
						</#if>
					<#else>
						itemstack.shrink(1);
						return itemstack;
					</#if>
				}
			}
			</#if>
			);
			</#list>
			<#list specialentities as entity>
			DispenserBlock.registerDispenseBehavior(${JavaModName}Items.${entity.getModElement().getRegistryNameUpper()}.get(),
					new ${JavaModName}BoatDispenseItemBehavior(${JavaModName}Boat.Type.${entity.getModElement().getRegistryNameUpper()}));
			</#list>
		});
	}

	<#if specialentities?size != 0>
	public static class ${JavaModName}BoatDispenseItemBehavior extends DefaultDispenseItemBehavior {
	    private final DefaultDispenseItemBehavior dispenseItemBehaviour = new DefaultDispenseItemBehavior();
	    private final ${JavaModName}Boat.Type type;

	    public ${JavaModName}BoatDispenseItemBehavior(${JavaModName}Boat.Type type) {
	        this.type = type;
	    }

	    @Override ${mcc.getMethod("net.minecraft.dispenser.DispenseBoatBehavior", "dispenseStack", "IBlockSource", "ItemStack").replace("BoatEntity", JavaModName + "Boat")}

	    @Override ${mcc.getMethod("net.minecraft.dispenser.DispenseBoatBehavior", "playDispenseSound", "IBlockSource")}
	}
	</#if>
}</@javacompress>