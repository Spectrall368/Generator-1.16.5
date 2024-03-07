<#include "mcelements.ftl">
if (${input$entity} instanceof ServerPlayerEntity)
    ((ServerPlayerEntity) ${input$entity}).server.getRecipeManager().getRecipe(${toResourceLocation(input$recipe)}).ifPresent(_rec -> ((ServerPlayerEntity) ${input$entity}).resetRecipes(Collections.singleton(_rec)));
