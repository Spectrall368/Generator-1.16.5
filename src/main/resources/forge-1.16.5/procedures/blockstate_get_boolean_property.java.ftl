<#include "mcitems.ftl">
<@addTemplate file="utils/blockstate_props/property_from_string.java.ftl"/>
(getPropertyByName(${mappedBlockToBlockStateCode(input$block)}, ${input$property}) instanceof BooleanProperty && ${mappedBlockToBlockStateCode(input$block)}.get((BooleanProperty) getPropertyByName(${mappedBlockToBlockStateCode(input$block)}, ${input$property})))