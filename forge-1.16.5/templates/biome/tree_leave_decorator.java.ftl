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

public class ${name}LeaveDecorator extends LeaveVineTreeDecorator {

        public static final ${name}LeaveDecorator INSTANCE = new ${name}LeaveDecorator();

        public static com.mojang.serialization.Codec<LeaveVineDecorator> codec;
        public static TreeDecoratorType<?> tdt;

        static {
            codec = com.mojang.serialization.Codec.unit(() -> INSTANCE);
            tdt = new TreeDecoratorType<>(codec);
            tdt.setRegistryName("${registryname}_tree_leave_decorator");
            ForgeRegistries.TREE_DECORATOR_TYPES.register(tdt);
        }

        @Override
        protected TreeDecoratorType<?> type() {
            return tdt;
        }

		@Override protected void func_227424_a_(IWorldWriter ww, BlockPos bp, BooleanProperty bpr, Set<BlockPos> sbc, MutableBoundingBox mbb) {
			this.func_227423_a_(ww, bp, ${mappedBlockToBlockStateCode(data.treeVines)}, sbc, mbb);
		}
}
<#-- @formatter:on -->
