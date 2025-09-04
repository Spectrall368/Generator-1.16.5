private static int drainTankSimulate(IWorld level, BlockPos pos, int amount, Direction direction) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null)
        entity.getCapability(CapabilityFluidHandler.FLUID_HANDLER_CAPABILITY, direction)
		    .ifPresent(capability -> result.set(capability.drain(amount, IFluidHandler.FluidAction.SIMULATE).getAmount()));

	return result.get();
}