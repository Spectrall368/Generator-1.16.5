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
package ${package}.world.features.treedecorators;
<#include "../mcitems.ftl">

public class ${name}FruitDecorator extends CocoaTreeDecorator {

    public static final ${name}FruitDecorator INSTANCE = new ${name}FruitDecorator();

    public static com.mojang.serialization.Codec<${name}FruitDecorator> codec;
    public static TreeDecoratorType<?> tdt;

    static {
        codec = com.mojang.serialization.Codec.unit(() -> INSTANCE);
        tdt = new TreeDecoratorType<>(codec);
        tdt.setRegistryName("${registryname}_tree_fruit_decorator");
        ForgeRegistries.TREE_DECORATOR_TYPES.register(tdt);
    }

    public ${name}FruitDecorator() {
        super(0.2f);
    }

    @Override protected TreeDecoratorType<?> type() {
        return tdt;
    }

		@Override ${mcc.getMethod("net.minecraft.world.gen.treedecorator.CocoaTreeDecorator", "func_225576_a_", "ISeedReader", "Random", "List", "List", "Set", "MutableBoundingBox")
			.replace("this.field_227417_b_", "0.2F")
			.replace("Blocks.COCOA.getDefaultState().with(CocoaBlock.AGE,Integer.valueOf(p_225576_2_.nextInt(3))).with(CocoaBlock.HORIZONTAL_FACING,direction)",
				mappedBlockToBlockStateCode(data.treeFruits))}

}
<#-- @formatter:on -->
