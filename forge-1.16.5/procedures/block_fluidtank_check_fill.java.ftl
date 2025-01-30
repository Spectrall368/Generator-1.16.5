<#include "mcelements.ftl">
<#-- @formatter:off -->
/*@int*/(new Object(){
	public int fillTankSimulate(IWorld world, BlockPos pos, int amount) {
		AtomicInteger _retval = new AtomicInteger(0);
		TileEntity _ent = world.getTileEntity(pos);
		if (_ent != null)
			_ent.getCapability(CapabilityFluidHandler.FLUID_HANDLER_CAPABILITY, ${input$direction}).ifPresent(capability ->
				_retval.set(capability.fill(new FluidStack(${generator.map(field$fluid, "fluids")}, amount), IFluidHandler.FluidAction.SIMULATE))
		);
		return _retval.get();
	}
}.fillTankSimulate(world, ${toBlockPos(input$x,input$y,input$z)},${opt.toInt(input$amount)}))
<#-- @formatter:on -->
