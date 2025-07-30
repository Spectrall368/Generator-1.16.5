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
package ${package}.client.renderer.item;

import net.minecraft.client.renderer.ItemRenderer;

<#compress>
@OnlyIn(Dist.CLIENT)
public class ${name}ItemRenderer extends ItemStackTileEntityRenderer {
	private final Supplier<ItemStack> transformSource;

	public ${name}ItemRenderer() {
		this.transformSource = () -> new ItemStack(${JavaModName}Items.${REGISTRYNAME}.get());
	}

	@Override public void func_239207_a_(ItemStack itemstack, ItemCameraTransforms.TransformType displayContext, MatrixStack poseStack, IRenderTypeBuffer bufferSource, int packedLight, int packedOverlay) {
		Model model = <#if data.hasCustomJAVAModel()>new ${data.customModelName.split(":")[0]}()<#else>null</#if>;
		ResourceLocation texture = new ResourceLocation("${data.texture.format("%s:textures/item/%s")}.png");
		<#list data.getModels() as model>
			<#if model.hasCustomJAVAModel()>
			if (<#list model.stateMap.entrySet() as entry>
					ItemModelsProperties.func_239417_a_(itemstack, new ResourceLocation("${generator.map(entry.getKey().getPrefixedName(registryname + "_"), "itemproperties")}"))
						.call(itemstack, Minecraft.getInstance().world, Minecraft.getInstance().player) >= ${entry.getValue()?is_boolean?then(entry.getValue()?then("1", "0"), entry.getValue())}
				<#sep> && </#list>) {
				model = new ${model.customModelName.split(":")[0]}();
				texture = new ResourceLocation("${model.texture.format("%s:textures/item/%s")}.png");
			}
			</#if>
		</#list>
		if (model == null) return;

		poseStack.push();
		Minecraft.getInstance().getItemRenderer().getItemModelWithOverrides(this.transformSource.get(), null, null).handlePerspective(displayContext, poseStack);
		poseStack.translate(0.5, isInventory(displayContext) ? 1.5 : 2, 0.5);
		poseStack.scale(1, -1, displayContext == ItemCameraTransforms.TransformType.GUI ? -1 : 1);
		IVertexBuilder vertexConsumer = ItemRenderer.getEntityGlintVertexBuilder(bufferSource, model.getRenderType(texture), false, itemstack.hasEffect());
		model.render(poseStack, vertexConsumer, packedLight, packedOverlay, 1, 1, 1, 1);
		poseStack.pop();
	}

	private static boolean isInventory(ItemCameraTransforms.TransformType type) {
		return type == ItemCameraTransforms.TransformType.GUI || type == ItemCameraTransforms.TransformType.FIXED;
	}
}
</#compress>
<#-- @formatter:on -->