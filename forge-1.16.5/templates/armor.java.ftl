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

			@Override public net.minecraft.util.SoundEvent getSoundEvent() {
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
			super(EquipmentSlotType.HEAD, new Item.Properties().group(${data.creativeTab})<#if data.helmetImmuneToFire>.isImmuneToFire()</#if>);
		}

		<#if data.helmetModelName != "Default" && data.getHelmetModel()??>
		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
			BipedModel armorModel = new BipedModel(1);
			armorModel.bipedHead = new ${data.helmetModelName}().${data.helmetModelPart};
			armorModel.isSneak = living.isSneaking();
			armorModel.isSitting = defaultModel.isSitting;
			armorModel.isChild = living.isChild();
			return armorModel;
		}
		</#if>

		<@addSpecialInformation data.helmetSpecialInfo/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			<#if data.helmetModelTexture?has_content && data.helmetModelTexture != "From armor">
			return "${modid}:textures/entities/${data.helmetModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png";
			</#if>
		}

		<@onArmorTick data.onHelmetTick/>
	}
	</#if>

	<#if data.enableBody>
	public static class Chestplate extends ${name}Item {

		public Chestplate() {
			super(EquipmentSlotType.CHEST, new Item.Properties().group(${data.creativeTab})<#if data.bodyImmuneToFire>.isImmuneToFire()</#if>);
		}

		<#if data.bodyModelName != "Default" && data.getBodyModel()??>
		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
			BipedModel armorModel = new BipedModel(1);
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
			return armorModel;
		}
		</#if>

		<@addSpecialInformation data.bodySpecialInfo/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			<#if data.bodyModelTexture?has_content && data.bodyModelTexture != "From armor">
			return "${modid}:textures/entities/${data.bodyModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png";
			</#if>
		}

		<@onArmorTick data.onBodyTick/>
	}
	</#if>

	<#if data.enableLeggings>
	public static class Leggings extends ${name}Item {

		public Leggings() {
			super(EquipmentSlotType.LEGS, new Item.Properties().group(${data.creativeTab})<#if data.leggingsImmuneToFire>.isImmuneToFire()</#if>);
		}

		<#if data.leggingsModelName != "Default" && data.getLeggingsModel()??>
		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
			BipedModel armorModel = new BipedModel(1);

			<#if data.leggingsModelPartL?has_content>
			armorModel.bipedLeftLeg = new ${data.leggingsModelName}().${data.leggingsModelPartL};
			</#if>
			<#if data.leggingsModelPartR?has_content>
			armorModel.bipedRightLeg = new ${data.leggingsModelName}().${data.leggingsModelPartR};
			</#if>

			armorModel.isSneak = living.isSneaking();
			armorModel.isSitting = defaultModel.isSitting;
			armorModel.isChild = living.isChild();
			return armorModel;
		}
		</#if>

		<@addSpecialInformation data.leggingsSpecialInfo/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			<#if data.leggingsModelTexture?has_content && data.leggingsModelTexture != "From armor">
			return "${modid}:textures/entities/${data.leggingsModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_2.png";
			</#if>
		}

		<@onArmorTick data.onLeggingsTick/>
	}
	</#if>

	<#if data.enableBoots>
	public static class Boots extends ${name}Item {

		public Boots() {
			super(EquipmentSlotType.FEET, new Item.Properties().group(${data.creativeTab})<#if data.bootsImmuneToFire>.isImmuneToFire()</#if>);
		}

		<#if data.bootsModelName != "Default" && data.getBootsModel()??>
		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
			BipedModel armorModel = new BipedModel(1);

			<#if data.bootsModelPartL?has_content>
			armorModel.bipedLeftLeg = new ${data.bootsModelName}().${data.bootsModelPartL};
			</#if>
			<#if data.bootsModelPartR?has_content>
			armorModel.bipedRightLeg = new ${data.bootsModelName}().${data.bootsModelPartR};
			</#if>

			armorModel.isSneak = living.isSneaking();
			armorModel.isSitting = defaultModel.isSitting;
			armorModel.isChild = living.isChild();
			return armorModel;
		}
		</#if>

		<@addSpecialInformation data.bootsSpecialInfo/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			<#if data.bootsModelTexture?has_content && data.bootsModelTexture != "From armor">
			return "${modid}:textures/entities/${data.bootsModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png";
			</#if>
		}

		<@onArmorTick data.onBootsTick/>
	}
	</#if>

	<#if data.getArmorModelsCode()?? >
	${data.getArmorModelsCode().toString()
		.replace("extends ModelBase", "extends EntityModel<Entity>")
		.replace("RendererModel ", "ModelRenderer ")
		.replace("RendererModel(", "ModelRenderer(")
		.replace("GlStateManager.translate", "GlStateManager.translated")
		.replace("GlStateManager.scale", "GlStateManager.scaled")
		.replaceAll("(.*?)\\.cubeList\\.add\\(new\\sModelBox\\(", "addBoxHelper(")
		.replaceAll(",[\n\r\t\\s]+true\\)\\);", ", true);")
		.replaceAll(",[\n\r\t\\s]+false\\)\\);", ", false);")
		.replaceAll("setRotationAngles\\(float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5,[\n\r\t\\s]+Entity[\n\r\t\\s]+e\\)",
			"setRotationAngles(Entity e, float f, float f1, float f2, float f3, float f4)")
		.replaceAll("setRotationAngles\\(float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5,[\n\r\t\\s]+Entity[\n\r\t\\s]+entity\\)",
			"setRotationAngles(Entity entity, float f, float f1, float f2, float f3, float f4)")

		.replaceAll("((super\\.)?)setRotationAngles\\(f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5,[\n\r\t\\s]+e\\);",
					"")
		.replaceAll("((super\\.)?)setRotationAngles\\(f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5,[\n\r\t\\s]+entity\\);",
					"")

		.replaceAll("render\\(Entity[\n\r\t\\s]+entity,[\n\r\t\\s]+float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5\\)",
					"render(MatrixStack ms, IVertexBuilder vb, int i1, int i2, float f1, float f2, float f3, float f4)")
		.replaceAll("super\\.render\\(entity,[\n\r\t\\s]+f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5\\);", "")
		.replace(".render(f5);", ".render(ms, vb, i1, i2, f1, f2, f3, f4);")}

		<#if data.getArmorModelsCode().contains(".cubeList.add(new")> <#-- if the model is pre 1.15.2 -->
		@OnlyIn(Dist.CLIENT) public static void addBoxHelper(ModelRenderer renderer, int texU, int texV, float x, float y, float z, int dx, int dy, int dz, float delta) {
			addBoxHelper(renderer, texU, texV, x, y, z, dx, dy, dz, delta, renderer.mirror);
		}

		@OnlyIn(Dist.CLIENT) public static void addBoxHelper(ModelRenderer renderer, int texU, int texV, float x, float y, float z, int dx, int dy, int dz, float delta, boolean mirror) {
			renderer.mirror = mirror;
			renderer.addBox("", x, y, z, dx, dy, dz, delta, texU, texV);
		}
		</#if>
	</#if>
}
<#-- @formatter:on -->
