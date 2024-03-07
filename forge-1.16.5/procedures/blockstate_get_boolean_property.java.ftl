<#include "mcitems.ftl">
(${mappedBlockToBlock(input$block)}.getStateContainer().getProperty(${input$property}) instanceof BooleanProperty ? ${mappedBlockToBlockStateCode(input$block)}.get((BooleanProperty) ${mappedBlockToBlock(input$block)}.getStateContainer().getProperty(${input$property})) : false)
