private static BlockState blockStateWithEnum(BlockState blockState, String property, String newValue) {
	Property<?> prop = blockState.getBlock().getStateContainer().getProperty(property);
	return prop instanceof EnumProperty && ((EnumProperty) prop).parseValue(newValue).isPresent() ? blockState.with((EnumProperty) prop, (Enum) ((EnumProperty) prop).parseValue(newValue).get()) : blockState;
}