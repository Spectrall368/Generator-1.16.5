<#include "mcitems.ftl">
/*@int*/(${mappedBlockToBlock(input$block)}.getStateContainer().getProperty(${input$property}) instanceof IntegerProperty ? ${mappedBlockToBlockStateCode(input$block)}.get((IntegerProperty) ${mappedBlockToBlock(input$block)}.getStateContainer().getProperty(${input$property})) : -1)
