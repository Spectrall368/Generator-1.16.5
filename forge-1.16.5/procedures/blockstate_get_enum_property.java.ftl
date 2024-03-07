<#include "mcitems.ftl">
(${mappedBlockToBlock(input$block)}.getStateContainer().getProperty(${input$property}) instanceof EnumProperty ? ${mappedBlockToBlockStateCode(input$block)}.get((EnumProperty<?>) ${mappedBlockToBlock(input$block)}.getStateContainer().getProperty(${input$property})).toString() : "")
