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
<#include "../procedures.java.ftl">
package ${package}.client.renderer;

@OnlyIn(Dist.CLIENT) public class ${name}Renderer {

	public static class ModelRegisterHandler {

		@SubscribeEvent @OnlyIn(Dist.CLIENT) public void registerModels(ModelRegistryEvent event) {
			<#if data.mobModelName == "Chicken">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new ChickenModel(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Cod">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new CodModel(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Cow">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new CowModel(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Creeper">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new CreeperModel(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Ghast">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new GhastModel(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Ocelot">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new OcelotModel(0), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Pig">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new PigModel(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Piglin">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new PiglinModel(0, 64, 64), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Salmon">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new SalmonModel(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Slime">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new SlimeModel(0), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Spider">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new SpiderModel(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Villager">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new VillagerModel(0), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Witch">
				RenderingRegistry.registerEntityRenderingHandler(${name}Entity.entity, renderManager -> new MobRenderer(renderManager, new WitchModel(0), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif data.mobModelName == "Silverfish">
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> new MobRenderer(renderManager, new SilverfishModel(), ${data.modelShadowSize}f) {
					<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
					@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
				});
            <#elseif !data.isBuiltInModel()>
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> {
					return new MobRenderer(renderManager, new ${data.mobModelName}(), ${data.modelShadowSize}f) {
						<#if data.mobModelGlowTexture?has_content>{ this.addLayer(new GlowingLayer<>(this)); }</#if>
						@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					<@renderConditions/>
					};
				});
            <#else>
				RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), renderManager -> {
					BipedRenderer customRender = new BipedRenderer(renderManager, new BipedModel(0), ${data.modelShadowSize}f) {
						@Override public ResourceLocation getEntityTexture(Entity entity) { return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}"); }
					    <@renderConditions/>
					};
					customRender.addLayer(new BipedArmorLayer(customRender, new BipedModel(0.5f), new BipedModel(1)));
					<#if data.mobModelGlowTexture?has_content>customRender.addLayer(new GlowingLayer<>(customRender));</#if>
					return customRender;
				});
            </#if>

			<#if data.ranged && data.rangedItemType == "Default item" && !data.rangedAttackItem.isEmpty()>
			RenderingRegistry.registerEntityRenderingHandler(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}_PROJECTILE.get(), renderManager -> new SpriteRenderer(renderManager, Minecraft.getInstance().getItemRenderer()));
            </#if>
		}
	}

    <#if data.mobModelGlowTexture?has_content>
	@OnlyIn(Dist.CLIENT) private static class GlowingLayer<T extends Entity, M extends EntityModel<T>> extends LayerRenderer<T, M> {

		public GlowingLayer(IEntityRenderer<T, M> er) {
			super(er);
		}

		public void render(MatrixStack matrixStackIn, IRenderTypeBuffer bufferIn, int packedLightIn, T entitylivingbaseIn, float limbSwing,
				float limbSwingAmount, float partialTicks, float ageInTicks, float netHeadYaw, float headPitch) {
			IVertexBuilder ivertexbuilder = bufferIn.getBuffer(RenderType.getEyes(new ResourceLocation("${modid}:textures/entities/${data.mobModelGlowTexture}")));
			this.getEntityModel().render(matrixStackIn, ivertexbuilder, 15728640, OverlayTexture.NO_OVERLAY, 1, 1, 1, 1);
		}

	}
    </#if>

    <#if data.getModelCode()?? && !data.isBuiltInModel()>
        ${data.getModelCode().toString()
        .replace("extends ModelBase", "extends EntityModel<Entity>")
        .replace("GlStateManager.translate", "GlStateManager.translated")
        .replace("RendererModel ", "ModelRenderer ")
        .replace("RendererModel(", "ModelRenderer(")
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
        .replace(".render(f5);", ".render(ms, vb, i1, i2, f1, f2, f3, f4);")
        }

        <#if data.getModelCode().contains(".cubeList.add(new")> <#-- if the model is pre 1.15.2 -->
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
<#macro renderConditions>
    <#if hasProcedure(data.transparentModelCondition)>
        @Override protected boolean isVisible(LivingEntity _ent) {
	        Entity entity = _ent;
	        World world = entity.world;
	        double x = entity.getPosX();
	        double y = entity.getPosY();
	        double z = entity.getPosZ();
		    return !<@procedureOBJToConditionCode data.transparentModelCondition/>;
	    }
    </#if>

    <#if hasProcedure(data.isShakingCondition)>
        @Override protected boolean func_230495_a_(LivingEntity _ent) {
	        Entity entity = _ent;
	        World world = entity.world;
	        double x = entity.getPosX();
	        double y = entity.getPosY();
	        double z = entity.getPosZ();
		    return <@procedureOBJToConditionCode data.isShakingCondition/>;
	    }
    </#if>
</#macro>
