<#include "mcelements.ftl">
(ItemTags.getCollection().getTagByID(${toResourceLocation(input$tag)}).getRandomElement(new Random()).orElseGet(() -> Items.AIR))
