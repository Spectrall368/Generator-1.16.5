<#include "mcelements.ftl">
<#-- @formatter:off -->
/*@int*/(new Object() {
	public int getAmount(IWorld world, BlockPos pos,int slotid) {
		AtomicInteger _retval = new AtomicInteger(0);
		TileEntity _ent = world.getTileEntity(pos);
		if (_ent != null)
			_ent.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)
				.ifPresent(capability -> _retval.set(capability.getStackInSlot(slotid).getCount()));
		return _retval.get();
	}
}.getAmount(world, ${toBlockPos(input$x,input$y,input$z)}, ${opt.toInt(input$slotid)}))
<#-- @formatter:on -->
