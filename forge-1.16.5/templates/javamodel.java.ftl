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
package ${package}.client.model;

${model.toString()
    .replace("public static class", "public class")
    .replace("extends ModelBase", "extends EntityModel<Entity>")
    .replace("extends EntityModel", "extends EntityModel<Entity>")
    .replace(" extends EntityModel<Entity>", "<T extends Entity> extends EntityModel<T>")
    .replace("GlStateManager.translate", "GlStateManager.translated")
    .replace("GlStateManager.scale", "GlStateManager.scaled")
    .replace("RendererModel ", "ModelRenderer ")
    .replace("RendererModel(", "ModelRenderer(")
    .replace("private final ModelRenderer", "public final ModelRenderer")
    .replaceAll("(.*?)\\.cubeList\\.add\\(new\\sModelBox\\(", "addBoxHelper(")
    .replaceAll(",[\n\r\t\\s]+true\\)\\);", ", true);")
    .replaceAll(",[\n\r\t\\s]+false\\)\\);", ", false);")
    .replaceAll("setRotationAngles\\(float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5,[\n\r\t\\s]+Entity[\n\r\t\\s]+e\\)", "setRotationAngles(Entity e, float f, float f1, float f2, float f3, float f4)")
    .replaceAll("setRotationAngles\\(float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5,[\n\r\t\\s]+Entity[\n\r\t\\s]+entity\\)", "setRotationAngles(Entity entity, float f, float f1, float f2, float f3, float f4)")
    .replaceAll("((super\\.)?)setRotationAngles\\(f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5,[\n\r\t\\s]+e\\);", "")
    .replaceAll("((super\\.)?)setRotationAngles\\(f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5,[\n\r\t\\s]+entity\\);", "")
    .replaceAll("render\\(Entity[\n\r\t\\s]+entity,[\n\r\t\\s]+float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5\\)", "render(MatrixStack ms, IVertexBuilder vb, int i1, int i2, float f1, float f2, float f3, float f4)")
    .replaceAll("super\\.render\\(entity,[\n\r\t\\s]+f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5\\);", "")
    .replace(".render(f5);", ".render(ms, vb, i1, i2, f1, f2, f3, f4);")
}?remove_ending("}")

    <#if model.contains(".cubeList.add(new")> <#-- if the model is pre 1.15.2 -->
    @OnlyIn(Dist.CLIENT) public static void addBoxHelper(ModelRenderer renderer, int texU, int texV, float x, float y, float z, int dx, int dy, int dz, float delta) {
     addBoxHelper(renderer, texU, texV, x, y, z, dx, dy, dz, delta, renderer.mirror);
    }
	
    @OnlyIn(Dist.CLIENT) public static void addBoxHelper(ModelRenderer renderer, int texU, int texV, float x, float y, float z, int dx, int dy, int dz, float delta, boolean mirror) {
     renderer.mirror = mirror;
     renderer.addBox("", x, y, z, dx, dy, dz, delta, texU, texV);
    }
    </#if>
}
<#-- @formatter:on -->
