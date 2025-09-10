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
<#include "../procedures.java.ftl">
package ${package}.client.renderer;
<#assign humanoid = false>
<#assign model = "PlayerModel">

<#if data.mobModelName == "Chicken">
	<#assign rootPart = "">
	<#assign model = "ChickenModel">
<#elseif data.mobModelName == "Cod">
	<#assign rootPart = "">
	<#assign model = "CodModel">
<#elseif data.mobModelName == "Cow">
	<#assign rootPart = "">
	<#assign model = "CowModel">
<#elseif data.mobModelName == "Creeper">
	<#assign rootPart = "">
	<#assign model = "CreeperModel">
<#elseif data.mobModelName == "Ghast">
	<#assign rootPart = "">
	<#assign model = "GhastModel">
<#elseif data.mobModelName == "Ocelot">
	<#assign rootPart = "0.0F">
	<#assign model = "OcelotModel">
<#elseif data.mobModelName == "Pig">
	<#assign rootPart = "">
	<#assign model = "PigModel">
<#elseif data.mobModelName == "Piglin">
	<#assign rootPart = "0.0F, 64, 64">
	<#assign model = "PiglinModel">
<#elseif data.mobModelName == "Slime">
	<#assign rootPart = "16">
	<#assign model = "SlimeModel">
<#elseif data.mobModelName == "Salmon">
	<#assign rootPart = "">
	<#assign model = "SalmonModel">
<#elseif data.mobModelName == "Spider">
	<#assign rootPart = "">
	<#assign model = "SpiderModel">
<#elseif data.mobModelName == "Villager">
	<#assign rootPart = "0.0F">
	<#assign model = "VillagerModel">
<#elseif data.mobModelName == "Silverfish">
	<#assign rootPart = "">
	<#assign model = "SilverfishModel">
<#elseif data.mobModelName == "Witch">
	<#assign rootPart = "0">
	<#assign model = "WitchModel">
<#elseif !data.isBuiltInModel()>
	<#assign rootPart = "">
	<#assign model = data.mobModelName>
<#else>
	<#assign rootPart = "0.0F, false">
	<#assign model = "PlayerModel">
	<#assign humanoid = true>
</#if>
<#assign model = model + "<" + name + "Entity>">
<#compress>
@OnlyIn(Dist.CLIENT)
public class ${name}Renderer extends <#if humanoid>Biped<#else>Mob</#if>Renderer<${name}Entity, ${model}> {

	public ${name}Renderer(EntityRendererManager context) {
		super(context, new ${model}(${rootPart}), ${data.modelShadowSize}f);

		<#if humanoid>
		this.addLayer(new BipedArmorLayer(this, new BipedModel(0.5F), new BipedModel(1.0F)));
		<#elseif data.mobModelName == "Villager">
		this.addLayer(new CrossedArmsItemLayer<>(this));
		<#elseif data.mobModelName == "Witch">
		this.addLayer(new WitchHeldItemLayer<>(this));
		</#if>

		<#list data.modelLayers as layer>
		this.addLayer(new LayerRenderer<${name}Entity, ${model}>(this) {
			final ResourceLocation LAYER_TEXTURE = new ResourceLocation("${modid}:textures/entities/${layer.texture}");

			<#compress>
			@Override public void render(MatrixStack poseStack, IRenderTypeBuffer bufferSource, int light,
						${name}Entity entity, float limbSwing, float limbSwingAmount, float partialTicks, float ageInTicks, float netHeadYaw, float headPitch) {
				<#if hasProcedure(layer.condition)>
				World world = entity.world;
				double x = entity.getPosX();
				double y = entity.getPosY();
				double z = entity.getPosZ();
				if (<@procedureOBJToConditionCode layer.condition/>) {
				</#if>

				IVertexBuilder vertexConsumer = bufferSource.getBuffer(RenderType.<#if layer.glow>getEyes<#else>getEntityCutoutNoCull</#if>(LAYER_TEXTURE));
				<#if layer.model != "Default">
					EntityModel model = new ${layer.model}();
					this.getEntityModel().copyModelAttributesTo(model);
					model.setLivingAnimations(entity, limbSwing, limbSwingAmount, partialTicks);
					model.setRotationAngles(entity, limbSwing, limbSwingAmount, ageInTicks, netHeadYaw, headPitch);
					model.render(poseStack, vertexConsumer, light,
						<#if layer.disableHurtOverlay>OverlayTexture.NO_OVERLAY<#else>LivingRenderer.getPackedOverlay(entity, 0)</#if>, 1, 1, 1, 1);
				<#else>
					this.getEntityModel().render(poseStack, vertexConsumer, light,
						<#if layer.disableHurtOverlay>OverlayTexture.NO_OVERLAY<#else>LivingRenderer.getPackedOverlay(entity, 0)</#if>, 1, 1, 1, 1);
				</#if>

				<#if hasProcedure(layer.condition)>}</#if>
			}
			</#compress>
		});
		</#list>
	}

	<#if data.mobModelName == "Villager" || data.breedable || (data.visualScale?? && (data.visualScale.getFixedValue() != 1 || hasProcedure(data.visualScale)))>
	@Override protected void preRenderCallback(${name}Entity entity, MatrixStack poseStack, float f) {
		<#if hasProcedure(data.visualScale)>
			World world = entity.world;
			double x = entity.getPosX();
			double y = entity.getPosY();
			double z = entity.getPosZ();
			float scale = (float) <@procedureOBJToNumberCode data.visualScale/>;
			poseStack.scale(scale, scale, scale);
		<#elseif data.visualScale?? && data.visualScale.getFixedValue() != 1>
			poseStack.scale(${data.visualScale.getFixedValue()}f, ${data.visualScale.getFixedValue()}f, ${data.visualScale.getFixedValue()}f);
		</#if>
		<#if data.mobModelName == "Villager">
			poseStack.scale(0.9375f, 0.9375f, 0.9375f);
		</#if>
		<#if data.breedable>
			poseStack.scale(entity.getRenderScale(), entity.getRenderScale(), entity.getRenderScale());
		</#if>
	}
	</#if>

	@Override public ResourceLocation getEntityTexture(${name}Entity entity) {
		return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}");
	}

	<#if data.transparentModelCondition?? && (hasProcedure(data.transparentModelCondition) || data.transparentModelCondition.getFixedValue())>
	@Override protected boolean isVisible(${name}Entity entity) {
		<#if hasProcedure(data.transparentModelCondition)>
		World world = entity.world;
		double x = entity.getPosX();
		double y = entity.getPosY();
		double z = entity.getPosZ();
		</#if>
		return <@procedureOBJToConditionCode data.transparentModelCondition false true/>;
	}
	</#if>

	<#if data.isShakingCondition?? && (hasProcedure(data.isShakingCondition) || data.isShakingCondition.getFixedValue())>
	@Override protected boolean func_230495_a_(${name}Entity entity) {
		<#if hasProcedure(data.isShakingCondition)>
		World world = entity.world;
		double x = entity.getPosX();
		double y = entity.getPosY();
		double z = entity.getPosZ();
		</#if>
		return <@procedureOBJToConditionCode data.isShakingCondition/>;
	}
	</#if>
}
</#compress>
