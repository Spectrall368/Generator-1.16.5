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
<#include "../mcitems.ftl">
<#assign tabMap = w.getCreativeTabMap()>
<#assign customTabs = tabMap.keySet()?filter(e -> e?starts_with('CUSTOM:'))>
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

<#compress>
public class ${JavaModName}Tabs {

    <#list customTabs as customTab>
    <#assign tab = w.getWorkspace().getModElementByName(customTab.replace("CUSTOM:", "")).getGeneratableElement()>
    public static ItemGroup TAB_${tab.getModElement().getRegistryNameUpper()};
    </#list>

	public static void load() {
    	<#list customTabs as customTab>
    	<#assign tab = w.getWorkspace().getModElementByName(customTab.replace("CUSTOM:", "")).getGeneratableElement()>
        TAB_${tab.getModElement().getRegistryNameUpper()} = new ItemGroup("${modid}.${tab.getModElement().getRegistryName()}") {
			@Override @OnlyIn(Dist.CLIENT) public ItemStack createIcon() {
				return ${mappedMCItemToItemStackCode(tab.icon, 1)};
			}

			@Override public boolean hasSearchBar() {
				return ${tab.showSearch};
			}
        }<#if tab.showSearch>.setBackgroundImageName("item_search.png")</#if>;
        </#list>
    }
}
</#compress>
<#-- @formatter:on -->
