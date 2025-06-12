private static Direction getDirectionFromBlockState(BlockState blockState) {
	Property<?> prop = blockState.getBlock().getStateContainer().getProperty("facing");
	if (prop instanceof DirectionProperty) return blockState.get((DirectionProperty) prop);
	prop = blockState.getBlock().getStateContainer().getProperty("axis");
	return prop instanceof EnumProperty && ((EnumProperty) prop).getAllowedValues().toArray()[0] instanceof Direction.Axis ?
		Direction.getFacingFromAxisDirection((Direction.Axis) blockState.get((EnumProperty) prop), Direction.AxisDirection.POSITIVE) : Direction.NORTH;
}