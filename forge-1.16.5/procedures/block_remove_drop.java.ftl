<#include "mcelements.ftl">
{
    if(world instanceof World) {
	    BlockPos _pos = ${toBlockPos(input$x,input$y,input$z)};
	    Block.spawnDrops(world.getBlockState(_pos), (World) world, ${toBlockPos(input$x2,input$y2,input$z2)});
	    world.destroyBlock(_pos, false);
	}
}
