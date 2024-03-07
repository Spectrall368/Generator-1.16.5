<#include "mcelements.ftl">
<#-- @formatter:off -->
/*@ItemStack*/(new Object() {
	public ItemStack getItemStack(IWorld world, BlockPos pos, int slotid) {
		AtomicReference<ItemStack> _retval = new AtomicReference<>(ItemStack.EMPTY);
		TileEntity _ent = world.getTileEntity(pos);
		if (_ent != null)
			_ent.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)
				.ifPresent(capability -> _retval.set(capability.getStackInSlot(slotid).copy()));
		return _retval.get();
	}
}.getItemStack(world, ${toBlockPos(input$x,input$y,input$z)}, ${opt.toInt(input$slotid)}))
<#-- @formatter:on -->
