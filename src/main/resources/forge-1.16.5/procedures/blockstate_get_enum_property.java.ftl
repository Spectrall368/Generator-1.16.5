<#include "mcitems.ftl">
<@addTemplate file="utils/blockstate_props/property_from_string.java.ftl"/>
(getPropertyByName(${mappedBlockToBlockStateCode(input$block)}, ${input$property}) instanceof EnumProperty ? ${mappedBlockToBlockStateCode(input$block)}.get((EnumProperty) getPropertyByName(${mappedBlockToBlockStateCode(input$block)}, ${input$property})).toString() : "")