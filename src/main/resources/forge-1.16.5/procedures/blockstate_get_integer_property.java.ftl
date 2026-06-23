<#include "mcitems.ftl">
<@addTemplate file="utils/blockstate_props/property_from_string.java.ftl"/>
/*@int*/(getPropertyByName(${mappedBlockToBlockStateCode(input$block)}, ${input$property}) instanceof IntegerProperty ? ${mappedBlockToBlockStateCode(input$block)}.get((IntegerProperty) getPropertyByName(${mappedBlockToBlockStateCode(input$block)}, ${input$property})) : -1)