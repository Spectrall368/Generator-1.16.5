private static ItemStack commandParameterItemStack(CommandContext<CommandSource> arguments, String parameter) {
	ItemInput input = ItemArgument.getItem(arguments, parameter);
	try {
		return input.createStack(1, false);
	} catch (CommandSyntaxException e) {
		e.printStackTrace();
		return input.getItem().getDefaultInstance();
	}
}