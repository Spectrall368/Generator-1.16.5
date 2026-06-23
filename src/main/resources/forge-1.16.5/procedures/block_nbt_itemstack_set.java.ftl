<#include "mcelements.ftl">
<#include "mcitems.ftl">
<@head>
if (!world.isRemote()) {
	BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
	TileEntity _blockEntity = world.getTileEntity(_bp);
	BlockState _bs = world.getBlockState(_bp);
	if(_blockEntity != null) {
</@head>
		_blockEntity.getTileData().put(${input$tagName}, !${mappedMCItemToItemStackCode(input$tagValue, 1)}.isEmpty() ? ${mappedMCItemToItemStackCode(input$tagValue, 1)}.write(new CompoundNBT()) : new CompoundNBT());
<@tail>
	}
	if(world instanceof World)
		((World) world).notifyBlockUpdate(_bp, _bs, _bs, 3);
}</@tail>