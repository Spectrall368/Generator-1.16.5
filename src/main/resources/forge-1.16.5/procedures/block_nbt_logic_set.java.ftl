<#include "mcelements.ftl">
<@head>
if (!world.isRemote()) {
	BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
	TileEntity _blockEntity = world.getTileEntity(_bp);
	BlockState _bs = world.getBlockState(_bp);
	if(_blockEntity != null) {
</@head>
		_blockEntity.getTileData().putBoolean(${input$tagName}, ${input$tagValue});
<@tail>
	}
	if(world instanceof World)
		((World) world).notifyBlockUpdate(_bp, _bs, _bs, 3);
}</@tail>