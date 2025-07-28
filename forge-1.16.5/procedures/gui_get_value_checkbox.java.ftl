<#if w.hasElementsOfType("gui")>
((${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) ? ((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) ${input$entity}).openContainer).getMenuState(1, "${field$checkbox}", false) : false)
<#else>false</#if>