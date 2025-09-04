private static int fillTankSimulate(IWorld level, BlockPos pos, int amount, Direction direction, Fluid fluid) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null)
        entity.getCapability(CapabilityFluidHandler.FLUID_HANDLER_CAPABILITY, direction)
		    .ifPresent(capability -> result.set(capability.fill(new FluidStack(fluid, amount), IFluidHandler.FluidAction.SIMULATE)));

	return result.get();
}