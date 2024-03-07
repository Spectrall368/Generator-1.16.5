<#include "mcelements.ftl">
<#-- @formatter:off -->
if(${input$entity} instanceof ServerPlayerEntity) {
	BlockPos _bpos = ${toBlockPos(input$x,input$y,input$z)};
	NetworkHooks.openGui((ServerPlayerEntity) ${input$entity}, new INamedContainerProvider() {
		@Override public ITextComponent getDisplayName() {
			return new StringTextComponent("${field$guiname}");
		}
		@Override public Container createMenu(int id, PlayerInventory inventory, PlayerEntity player) {
			return new ${(field$guiname)}Menu(id, inventory, new PacketBuffer(Unpooled.buffer()).writeBlockPos(_bpos));
		}
	}, _bpos);
}
<#-- @formatter:on -->
