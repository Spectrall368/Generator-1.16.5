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
package ${package}.client.renderer.block;

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT) public class ${name}Renderer extends TileEntityRenderer<${name}BlockEntity> {

	private final CustomHierarchicalModel model;
	private final ResourceLocation texture;

	${name}Renderer(TileEntityRendererDispatcher context) {
	    super(context);
		this.model = new CustomHierarchicalModel();
		this.texture = new ResourceLocation("${data.texture.format("%s:textures/block/%s")}.png");
	}

	@Override public void render(${name}BlockEntity blockEntity, float partialTick, MatrixStack poseStack, IRenderTypeBuffer renderer, int light, int overlayLight) {
		<#compress>
		poseStack.push();
		poseStack.scale(-1, -1, 1);
		poseStack.translate(-0.5, -0.5, 0.5);
		<#if data.rotationMode != 0>
			BlockState state = blockEntity.getBlockState();
        	<#if data.rotationMode != 5>
				Direction facing = state.get(${name}Block.FACING);
        	    switch (facing) {
					case NORTH: break;
					case EAST:
						poseStack.rotate(Axis.YP.rotationDegrees(90));
						break;
					case WEST: 
						poseStack.rotate(Axis.YP.rotationDegrees(-90));
						break;
					case SOUTH:
						poseStack.rotate(Axis.YP.rotationDegrees(180));
						break;
        	    	<#if data.rotationMode == 2 || data.rotationMode == 4>
        	    		case UP:
							poseStack.rotate(Axis.XN.rotationDegrees(90));
							break;
        	    		case DOWN:
							poseStack.rotate(Axis.XN.rotationDegrees(-90));
							break;
					</#if>
				}
				<#if data.enablePitch>
				if (facing != Direction.UP && facing != Direction.DOWN) {
					switch (state.get(${name}Block.FACE)) {
						case FLOOR: break;
						case WALL:
							poseStack.rotate(Axis.XP.rotationDegrees(90));
							break;
						case CEILING:
							poseStack.rotate(Axis.XP.rotationDegrees(180));
							break;
					};
				}
				</#if>
			<#else>
        	    switch (state.get(${name}Block.AXIS)) {
					case X:
						poseStack.rotate(Axis.ZN.rotationDegrees(90));
						break;
					case Y: break;
					case Z:
						poseStack.rotate(Axis.XP.rotationDegrees(90));
						break;
				}
			</#if>
		</#if>
		poseStack.translate(0, -1, 0);
		IVertexBuilder builder = renderer.getBuffer(RenderType.getEntityCutout(texture));
		model.setupBlockEntityAnim(blockEntity, blockEntity.getWorld().getGameTime() + partialTick);
		model.render(poseStack, builder, light, overlayLight, 1, 1, 1, 1);
		poseStack.pop();
		</#compress>
	}

	@SubscribeEvent public static void registerBlockEntityRenderers(FMLClientSetupEvent event) {
		renders();
	}

	@SubscribeEvent @OnlyIn(Dist.CLIENT) public static void registerBlockEntityModels(ModelRegistryEvent event) {
		renders();
	}

	private static void renders() {
		ClientRegistry.bindTileEntityRenderer(${JavaModName}BlockEntities.${REGISTRYNAME}.get(), ${name}Renderer::new);
	}

	private static final class CustomHierarchicalModel extends ${data.customModelName.split(":")[0]} {
		public CustomHierarchicalModel() {
			super();
		}

		public void setupBlockEntityAnim(${name}BlockEntity blockEntity, float ageInTicks) {
			super.setRotationAngles(null, 0, 0, ageInTicks, 0, 0);
		}
	}
}
<#-- @formatter:on -->
