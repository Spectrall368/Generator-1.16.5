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
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
<#include "triggers.java.ftl">
package ${package}.item;

<#compress>
<#if data.toolType == "Pickaxe" || data.toolType == "Axe" || data.toolType == "Sword" || data.toolType == "Spade"
		|| data.toolType == "Hoe" || data.toolType == "Shears" || data.toolType == "MultiTool">
public class ${name}Item extends ${data.toolType?replace("Spade", "Shovel")?replace("MultiTool", "Tiered")}Item {
	public ${name}Item () {
		super(<#if data.toolType == "Pickaxe" || data.toolType == "Axe" || data.toolType == "Sword"
				|| data.toolType == "Spade" || data.toolType == "Hoe" || data.toolType == "MultiTool">
			new IItemTier() {
				public int getMaxUses() {
					return ${data.usageCount};
				}

				public float getEfficiency() {
					return ${data.efficiency}f;
				}

				public float getAttackDamage() {
					<#if data.toolType == "Sword">
					return ${data.damageVsEntity - 4}f;
					<#elseif data.toolType == "Hoe">
					return ${data.damageVsEntity - 1}f;
					<#else>
					return ${data.damageVsEntity - 2}f;
					</#if>
				}

				public int getHarvestLevel() {
					return ${data.harvestLevel};
				}

				public int getEnchantability() {
					return ${data.enchantability};
				}

				public Ingredient getRepairMaterial() {
					<#if data.repairItems?has_content>
					return Ingredient.fromStacks(
						<#list data.repairItems as repairItem>
						${mappedMCItemToItemStackCode(repairItem,1)}<#sep>,
						</#list>
					);
					<#else>
					return Ingredient.EMPTY;
					</#if>
				}
			},

			<#if data.toolType!="MultiTool">
				<#if data.toolType=="Sword">3<#elseif data.toolType=="Hoe">0<#else>1</#if>,${data.attackSpeed - 4}f,
			</#if>

				new Item.Properties()
			 	.group(${data.creativeTab})
		<#elseif data.toolType=="Shears">
			new ShearsItem(Item.Properties()
				.group(${data.creativeTab})
				.maxDamage(${data.usageCount}))
		</#if>);
	}

	<#if data.toolType=="Shears">
		@Override public int getItemEnchantability() {
			return ${data.enchantability};
		}

		@Override public float getDestroySpeed(ItemStack stack, BlockState blockstate) {
			return ${data.efficiency}f;
		}

	<#elseif data.toolType=="MultiTool">
		@Override public boolean canHarvestBlock(BlockState blockstate) {
		      return ${data.harvestLevel} >= state.getHarvestLevel();
		   }

		@Override public float getDestroySpeed(ItemStack itemstack, BlockState blockstate) {
			return ${data.efficiency}f;
		}

		@Override public Multimap<String, AttributeModifier> getAttributeModifiers(EquipmentSlotType equipmentSlot) {
			Multimap<String, AttributeModifier> multimap = super.getAttributeModifiers(equipmentSlot);
				if (equipmentSlot == EquipmentSlotType.MAINHAND) {
		         		multimap.put(SharedMonsterAttributes.ATTACK_DAMAGE.getName(), new AttributeModifier(ATTACK_DAMAGE_MODIFIER, "Tool modifier", ${data.damageVsEntity - 1}f, AttributeModifier.Operation.ADDITION));
		         		multimap.put(SharedMonsterAttributes.ATTACK_SPEED.getName(), new AttributeModifier(ATTACK_SPEED_MODIFIER, "Tool modifier", ${data.attackSpeed - 4}, AttributeModifier.Operation.ADDITION));
		      		}
			return multimap;
		}
	</#if>

	<#if data.toolType=="MultiTool">
		<@onBlockDestroyedWith data.onBlockDestroyedWithTool, true/>

		<@onEntityHitWith data.onEntityHitWith, true/>
	<#else>
		<@onBlockDestroyedWith data.onBlockDestroyedWithTool/>

		<@onEntityHitWith data.onEntityHitWith/>
	</#if>

	<@onRightClickedInAir data.onRightClickedInAir/>

	<@commonMethods/>

}
<#elseif data.toolType=="Special">
public class ${name}Item extends Item {

	public ${name}Item() {
		super(new Item.Properties()
			.group(${data.creativeTab})
			.maxDamage(${data.usageCount})
		);
	}

	@Override public float getDestroySpeed(ItemStack itemstack, BlockState blockstate) {
	<#list data.blocksAffected as restrictionBlock>
        	if (blockstate.getBlock() == ${mappedBlockToBlock(restrictionBlock)})
                 	return ${data.efficiency}f;
        </#list>
		return 1;
	}

	<@onBlockDestroyedWith data.onBlockDestroyedWithTool, true/>

	<@onEntityHitWith data.onEntityHitWith, true/>
	
	<@onRightClickedInAir data.onRightClickedInAir/>

	@Override public int getItemEnchantability() {
		return ${data.enchantability};
	}

	@Override public Multimap<String, AttributeModifier> getAttributeModifiers(EquipmentSlotType equipmentSlot) {
		Multimap<String, AttributeModifier> multimap = super.getAttributeModifiers(equipmentSlot);
		if (equipmentSlot == EquipmentSlotType.MAINHAND) {
			multimap.put(SharedMonsterAttributes.ATTACK_DAMAGE.getName(), new AttributeModifier(ATTACK_DAMAGE_MODIFIER, "Tool modifier", ${data.damageVsEntity - 1}f, AttributeModifier.Operation.ADDITION));
			multimap.put(SharedMonsterAttributes.ATTACK_SPEED.getName(), new AttributeModifier(ATTACK_SPEED_MODIFIER, "Tool modifier", ${data.attackSpeed - 4}, AttributeModifier.Operation.ADDITION));
		}
		return multimap;
	}

	<@commonMethods/>
}
<#elseif data.toolType=="Fishing rod">
public class ${name}Item extends FishingRodItem {

	public ${name}Item() {
		super(new Item.Properties()
			.group(${data.creativeTab})
			.maxDamage(${data.usageCount})
		);
	}

	<#if data.repairItems?has_content>
	@Override public boolean getIsRepairable(ItemStack itemstack, ItemStack repairitem) {
                Item repairItem = repair.getItem();
                return
                <#list data.repairItems as repairItem>
                	repairItem == ${mappedMCItemToItem(repairItem)}
                	<#if repairItem?has_next>||</#if>
                </#list>;
	}
	</#if>

	@Override public int getItemEnchantability() {
		return ${data.enchantability};
	}

	<@onBlockDestroyedWith data.onBlockDestroyedWithTool/>

	<@onEntityHitWith data.onEntityHitWith/>

	<#if hasProcedure(data.onRightClickedInAir)>
	@Override public ActionResult<ItemStack> onItemRightClick(World world, PlayerEntity entity, Hand hand) {
		ActionResult<ItemStack> retval = super.onItemRightClick(world, entity, hand);
		ItemStack itemstack = retval.getResult();
		<@procedureCode data.onRightClickedInAir, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack"
		}/>

		return retval;
	}
	</#if>

	<@commonMethods/>
}
</#if>
</#compress>
<#macro commonMethods>
	<#if data.stayInGridWhenCrafting>
		@Override public boolean hasContainerItem() {
			return true;
		}

		<#if data.damageOnCrafting && data.usageCount != 0>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				ItemStack retval = new ItemStack(this);
				retval.setDamage(itemstack.getDamage() + 1);
				if(retval.getDamage() >= retval.getMaxDamage()) {
					return ItemStack.EMPTY;
				}
				return retval;
			}

			@Override public boolean isRepairable(ItemStack itemstack) {
				return false;
			}
		<#else>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				return new ItemStack(this);
			}

			<#if data.usageCount != 0>
				@Override public boolean isRepairable(ItemStack itemstack) {
					return false;
				}
			</#if>
		</#if>
	</#if>

	<@addSpecialInformation data.specialInfo/>

	<@onItemUsedOnBlock data.onRightClickedOnBlock/>

	<@onCrafted data.onCrafted/>

	<@onEntitySwing data.onEntitySwing/>

	<@onStoppedUsing data.onStoppedUsing/>

	<@onItemTick data.onItemInUseTick, data.onItemInInventoryTick/>

	<#if data.hasGlow>
	<@hasGlow data.glowCondition/>
	</#if>
</#macro>
<#-- @formatter:on -->
