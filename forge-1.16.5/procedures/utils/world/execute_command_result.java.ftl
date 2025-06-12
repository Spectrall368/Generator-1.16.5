private static String executeCommandGetResult(IWorld world, Vector3d pos, String command) {
	StringBuilder result = new StringBuilder();
	if (world instanceof ServerWorld) {
		ICommandSource dataConsumer = new ICommandSource() {
			@Override public void sendMessage(ITextComponent message, UUID uuid) {
				result.append(message.getString());
			}

			@Override public boolean shouldReceiveFeedback() {
				return true;
			}

			@Override public boolean shouldReceiveErrors() {
				return true;
			}

			@Override public boolean allowLogging() {
				return false;
			}
		};
		((ServerWorld) world).getServer().getCommandManager().handleCommand(new CommandSource(dataConsumer, pos, Vector2f.ZERO, (ServerWorld) world, 4, "", new StringTextComponent(""), ((ServerWorld) world).getServer(), null), command);
	}
	return result.toString();
}