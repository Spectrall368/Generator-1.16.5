<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
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

<@javacompress>
public abstract class ${name}Item extends ArmorItem {

	public ${name}Item(EquipmentSlotType type, Item.Properties properties) {
		super(new IArmorMaterial() {
			@Override public int getDurability(EquipmentSlotType type) {
				return new int[]{13, 15, 16, 11}[type.getIndex()] * ${data.maxDamage};
			}

			@Override public int getDamageReductionAmount(EquipmentSlotType type) {
				return new int[] { ${data.damageValueBoots}, ${data.damageValueLeggings}, ${data.damageValueBody}, ${data.damageValueHelmet} }[type.getIndex()];
			}

			@Override public int getEnchantability() {
				return ${data.enchantability};
			}

			@Override public SoundEvent getSoundEvent() {
				<#if data.equipSound?has_content && data.equipSound.getUnmappedValue()?has_content>
				return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.equipSound}"));
				<#else>
				return null;
				</#if>
			}

			@Override public Ingredient getRepairMaterial() {
				return ${mappedMCItemsToIngredient(data.repairItems)};
			}

			@Override @OnlyIn(Dist.CLIENT) public String getName() {
				return "${registryname}";
			}

			@Override public float getToughness() {
				return ${data.toughness}f;
			}

			@Override public float getKnockbackResistance() {
				return ${data.knockbackResistance}f;
			}
		}, type, properties);
	}

	<#if data.enableHelmet>
	public static class Helmet extends ${name}Item {

		public Helmet() {
			super(EquipmentSlotType.HEAD, new Item.Properties().group(<@CreativeTabs data.creativeTabs/>)<#if data.helmetImmuneToFire>.isImmuneToFire()</#if><#if data.rarity != "COMMON">.rarity(Rarity.${data.rarity})</#if>);
		}

		<#if data.helmetModelName != "Default" && data.getHelmetModel()??>
		private BipedModel armorModel = null;

		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
		    if (armorModel == null) {
		        armorModel = new BipedModel(1)
                        <#if data.helmetTranslucency>
                        {
                            @Override
                            public void render(MatrixStack poseStack, IVertexBuilder buffer, int packedLight, int packedOverlay, float r, float g, float b, float alpha) {
                                IVertexBuilder translucentTexture = Minecraft.getInstance().getRenderTypeBuffers().getBufferSource().getBuffer(RenderType.getEntityTranslucent(
                                    new ResourceLocation(
                                    <#if data.helmetModelTexture?has_content && data.helmetModelTexture != "From armor">
                                        ${JavaModName}Items.${REGISTRYNAME}_HELMET.get().getArmorTexture(null, null, null, null)
                                    <#else>
                                        "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png"
                                    </#if>)
                                ));
                                super.render(poseStack, translucentTexture, packedLight, packedOverlay, r, g, b, alpha);
                            }
                        }
                        </#if>;
		        armorModel.bipedHead = new ${data.helmetModelName}().${data.helmetModelPart};
		        armorModel.bipedHeadwear = new ${data.helmetModelName}().${data.helmetModelPart};
		        armorModel.isSneak = living.isSneaking();
		        armorModel.isSitting = defaultModel.isSitting;
		        armorModel.isChild = living.isChild();
		    }

		    return armorModel;
		}
		</#if>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			return "${modid}:textures/<#if data.helmetModelTexture?has_content && data.helmetModelTexture != "From armor">entities/${data.helmetModelTexture}<#else>models/armor/${data.armorTextureFile}_layer_1.png</#if>";
		}

		<@addSpecialInformation data.helmetSpecialInformation, "item." + modid + "." + registryname + "_helmet"/>

		<@hasGlow data.helmetGlowCondition/>

		<@piglinNeutral data.helmetPiglinNeutral/>

		<@onArmorTick data.onHelmetTick/>
	}
	</#if>

	<#if data.enableBody>
	public static class Chestplate extends ${name}Item {

		public Chestplate() {
			super(EquipmentSlotType.CHEST, new Item.Properties().group(<@CreativeTabs data.creativeTabs/>)<#if data.bodyImmuneToFire>.isImmuneToFire()</#if><#if data.rarity != "COMMON">.rarity(Rarity.${data.rarity})</#if>);
		}

		<#if data.bodyModelName != "Default" && data.getBodyModel()??>
		private BipedModel armorModel = null;

		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
		    if (armorModel == null) {
		        armorModel = new BipedModel(1)
                        <#if data.bodyTranslucency>
                        {
                            @Override
                            public void render(MatrixStack poseStack, IVertexBuilder buffer, int packedLight, int packedOverlay, float r, float g, float b, float alpha) {
                                IVertexBuilder translucentTexture = Minecraft.getInstance().getRenderTypeBuffers().getBufferSource().getBuffer(RenderType.getEntityTranslucent(
                                    new ResourceLocation(
                                    <#if data.bodyModelTexture?has_content && data.bodyModelTexture != "From armor">
                                        ${JavaModName}Items.${REGISTRYNAME}_CHESTPLATE.get().getArmorTexture(null, null, null, null)
                                    <#else>
                                        "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png"
                                    </#if>)
                                ));
                                super.render(poseStack, translucentTexture, packedLight, packedOverlay, r, g, b, alpha);
                            }
                        }
                        </#if>;
		        armorModel.bipedBody = new ${data.bodyModelName}().${data.bodyModelPart};

		        <#if data.armsModelPartL?has_content>
		        armorModel.bipedLeftArm = new ${data.bodyModelName}().${data.armsModelPartL};
		        </#if>
		        <#if data.armsModelPartR?has_content>
		        armorModel.bipedRightArm = new ${data.bodyModelName}().${data.armsModelPartR};
		        </#if>

		        armorModel.isSneak = living.isSneaking();
		        armorModel.isSitting = defaultModel.isSitting;
		        armorModel.isChild = living.isChild();
		    }

		    return armorModel;
		}
		</#if>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			return "${modid}:textures/<#if data.bodyModelTexture?has_content && data.bodyModelTexture != "From armor">entities/${data.bodyModelTexture}<#else>models/armor/${data.armorTextureFile}_layer_1.png</#if>";
		}

		<@addSpecialInformation data.bodySpecialInformation, "item." + modid + "." + registryname + "_chestplate"/>

		<@hasGlow data.bodyGlowCondition/>

		<@piglinNeutral data.bodyPiglinNeutral/>

		<@onArmorTick data.onBodyTick/>
	}
	</#if>

	<#if data.enableLeggings>
	public static class Leggings extends ${name}Item {

		public Leggings() {
			super(EquipmentSlotType.LEGS, new Item.Properties().group(<@CreativeTabs data.creativeTabs/>)<#if data.leggingsImmuneToFire>.isImmuneToFire()</#if><#if data.rarity != "COMMON">.rarity(Rarity.${data.rarity})</#if>);
		}

		<#if data.leggingsModelName != "Default" && data.getLeggingsModel()??>
		private BipedModel armorModel = null;

		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
		    if (armorModel == null) {
		        armorModel = new BipedModel(1)
                        <#if data.leggingsTranslucency>
                        {
                            @Override
                            public void render(MatrixStack poseStack, IVertexBuilder buffer, int packedLight, int packedOverlay, float r, float g, float b, float alpha) {
                                IVertexBuilder translucentTexture = Minecraft.getInstance().getRenderTypeBuffers().getBufferSource().getBuffer(RenderType.getEntityTranslucent(
                                    new ResourceLocation(
                                    <#if data.leggingsModelTexture?has_content && data.leggingsModelTexture != "From armor">
                                        ${JavaModName}Items.${REGISTRYNAME}_LEGGINGS.get().getArmorTexture(null, null, null, null)
                                    <#else>
                                        "${modid}:textures/models/armor/${data.armorTextureFile}_layer_2.png"
                                    </#if>)
                                ));
                                super.render(poseStack, translucentTexture, packedLight, packedOverlay, r, g, b, alpha);
                            }
                        }
                        </#if>;

		        <#if data.leggingsModelPartL?has_content>
		        armorModel.bipedLeftLeg = new ${data.leggingsModelName}().${data.leggingsModelPartL};
		        </#if>
		        <#if data.leggingsModelPartR?has_content>
		        armorModel.bipedRightLeg = new ${data.leggingsModelName}().${data.leggingsModelPartR};
		        </#if>

		        armorModel.isSneak = living.isSneaking();
		        armorModel.isSitting = defaultModel.isSitting;
		        armorModel.isChild = living.isChild();
		    }

		    return armorModel;
		}
		</#if>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			return "${modid}:textures/<#if data.leggingsModelTexture?has_content && data.leggingsModelTexture != "From armor">entities/${data.leggingsModelTexture}<#else>models/armor/${data.armorTextureFile}_layer_2.png</#if>";
		}

		<@addSpecialInformation data.leggingsSpecialInformation, "item." + modid + "." + registryname + "_leggings"/>

		<@hasGlow data.leggingsGlowCondition/>

		<@piglinNeutral data.leggingsPiglinNeutral/>

		<@onArmorTick data.onLeggingsTick/>
	}
	</#if>

	<#if data.enableBoots>
	public static class Boots extends ${name}Item {

		public Boots() {
			super(EquipmentSlotType.FEET, new Item.Properties().group(<@CreativeTabs data.creativeTabs/>)<#if data.bootsImmuneToFire>.isImmuneToFire()</#if><#if data.rarity != "COMMON">.rarity(Rarity.${data.rarity})</#if>);
		}

		<#if data.bootsModelName != "Default" && data.getBootsModel()??>
		private BipedModel armorModel = null;

		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
		    if (armorModel == null) {
		        armorModel = new BipedModel(1)
                        <#if data.bootsTranslucency>
                        {
                            @Override
                            public void render(MatrixStack poseStack, IVertexBuilder buffer, int packedLight, int packedOverlay, float r, float g, float b, float alpha) {
                                IVertexBuilder translucentTexture = Minecraft.getInstance().getRenderTypeBuffers().getBufferSource().getBuffer(RenderType.getEntityTranslucent(
                                    new ResourceLocation(
                                    <#if data.bootsModelTexture?has_content && data.bootsModelTexture != "From armor">
                                        ${JavaModName}Items.${REGISTRYNAME}_BOOTS.get().getArmorTexture(null, null, null, null)
                                    <#else>
                                        "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png"
                                    </#if>)
                                ));
                                super.render(poseStack, translucentTexture, packedLight, packedOverlay, r, g, b, alpha);
                            }
                        }
                        </#if>;

		        <#if data.bootsModelPartL?has_content>
		        armorModel.bipedLeftLeg = new ${data.bootsModelName}().${data.bootsModelPartL};
		        </#if>
		        <#if data.bootsModelPartR?has_content>
		        armorModel.bipedRightLeg = new ${data.bootsModelName}().${data.bootsModelPartR};
		        </#if>

		        armorModel.isSneak = living.isSneaking();
		        armorModel.isSitting = defaultModel.isSitting;
		        armorModel.isChild = living.isChild();
		    }

		    return armorModel;
		}
		</#if>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			return "${modid}:textures/<#if data.bootsModelTexture?has_content && data.bootsModelTexture != "From armor">entities/${data.bootsModelTexture}<#else>models/armor/${data.armorTextureFile}_layer_1.png</#if>";
		}

		<@addSpecialInformation data.bootsSpecialInformation, "item." + modid + "." + registryname + "_boots"/>

		<@hasGlow data.bootsGlowCondition/>

		<@piglinNeutral data.bootsPiglinNeutral/>

		<@onArmorTick data.onBootsTick/>
	}
	</#if>
}
</@javacompress>
<#-- @formatter:on -->