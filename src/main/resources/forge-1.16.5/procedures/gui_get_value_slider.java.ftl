<#if w.hasElementsOfType("gui")>
((${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) ? ((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) ${input$entity}).openContainer).getMenuState(2, "${field$slider}", 0.0) : 0.0)
<#else>0</#if>