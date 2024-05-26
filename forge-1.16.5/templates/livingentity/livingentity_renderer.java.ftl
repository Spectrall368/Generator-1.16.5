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
	<#assign super = "super(context, new ChickenModel(), " + data.modelShadowSize + "f);">
	<#assign model = "ChickenModel">
<#elseif data.mobModelName == "Cod">
	<#assign super = "super(context, new CodModel(), " + data.modelShadowSize + "f);">
	<#assign model = "CodModel">
<#elseif data.mobModelName == "Cow">
	<#assign super = "super(context, new CowModel(), " + data.modelShadowSize + "f);">
	<#assign model = "CowModel">
<#elseif data.mobModelName == "Creeper">
	<#assign super = "super(context, new CreeperModel(), " + data.modelShadowSize + "f);">
	<#assign model = "CreeperModel">
<#elseif data.mobModelName == "Ghast">
	<#assign super = "super(context, new GhastModel(), " + data.modelShadowSize + "f);">
	<#assign model = "GhastModel">
<#elseif data.mobModelName == "Ocelot">
	<#assign super = "super(context, new OcelotModel(0.0F), " + data.modelShadowSize + "f);">
	<#assign model = "OcelotModel">
<#elseif data.mobModelName == "Pig">
	<#assign super = "super(context, new PigModel(), " + data.modelShadowSize + "f);">
	<#assign model = "PigModel">
<#elseif data.mobModelName == "Piglin">
	<#assign super = "super(context, new PiglinModel(), " + data.modelShadowSize + "f);">
	<#assign model = "PiglinModel">
<#elseif data.mobModelName == "Slime">
	<#assign super = "super(context, new SlimeModel(16), " + data.modelShadowSize + "f);">
	<#assign model = "SlimeModel">
<#elseif data.mobModelName == "Salmon">
	<#assign super = "super(context, new SalmonModel(), " + data.modelShadowSize + "f);">
	<#assign model = "SalmonModel">
<#elseif data.mobModelName == "Spider">
	<#assign super = "super(context, new SpiderModel(), " + data.modelShadowSize + "f);">
	<#assign model = "SpiderModel">
<#elseif data.mobModelName == "Villager">
	<#assign super = "super(context, new VillagerModel(0.0F), " + data.modelShadowSize + "f);">
	<#assign model = "VillagerModel">
<#elseif data.mobModelName == "Silverfish">
	<#assign super = "super(context, new SilverfishModel(), " + data.modelShadowSize + "f);">
	<#assign model = "SilverfishModel">
<#elseif data.mobModelName == "Witch">
	<#assign super = "super(context, new WitchModel(), " + data.modelShadowSize + "f);">
	<#assign model = "WitchModel">
<#elseif !data.isBuiltInModel()>
	<#assign super = "super(context, new ${data.mobModelName}(), " + data.modelShadowSize + "f);">
	<#assign model = data.mobModelName>
<#else>
	<#assign super = "super(context, new PlayerModel(0.0F, false), " + data.modelShadowSize + "f);">
	<#assign model = "PlayerModel">
	<#assign humanoid = true>
</#if>

<#assign model = model + "<" + name + "Entity>">

public class ${name}Renderer extends <#if humanoid>Biped<#else>Mob</#if>Renderer<${name}Entity, ${model}> {

	public ${name}Renderer(EntityRendererManager context) {
		${super}

		<#if humanoid>
		this.addLayer(new BipedArmorLayer(this, new BipedModel(0.5F), new BipedModel(1.0F)));
		</#if>

		<#if data.mobModelGlowTexture?has_content>
		this.addLayer(new AbstractEyesLayer<${name}Entity, ${model}>(this) {
			@Override public RenderType getRenderType() {
				return RenderType.getEyes(new ResourceLocation("${modid}:textures/entities/${data.mobModelGlowTexture}"));
			}
		});
		</#if>
	}

	<#if data.mobModelName == "Villager">
	@Override protected void preRenderCallback(${name}Entity villager, MatrixStack poseStack, float f) {
		poseStack.scale(0.9375f, 0.9375f, 0.9375f);
	}
	</#if>

	@Override public ResourceLocation getEntityTexture(${name}Entity entity) {
		return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}");
	}

    <#if hasProcedure(data.transparentModelCondition)>
        @Override protected boolean isVisible(${name}Entity _ent) {
	        Entity entity = _ent;
	        World world = entity.world;
	        double x = entity.getPosX();
	        double y = entity.getPosY();
	        double z = entity.getPosZ();
		    return !<@procedureOBJToConditionCode data.transparentModelCondition/>;
	    }
	</#if>

    <#if hasProcedure(data.isShakingCondition)>
        @Override protected boolean func_230495_a_(${name}Entity _ent) {
	        Entity entity = _ent;
	        World world = entity.world;
	        double x = entity.getPosX();
	        double y = entity.getPosY();
	        double z = entity.getPosZ();
		    return <@procedureOBJToConditionCode data.isShakingCondition/>;
	    }
	</#if>
}
