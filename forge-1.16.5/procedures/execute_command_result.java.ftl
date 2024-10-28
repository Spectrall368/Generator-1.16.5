<#-- @formatter:off -->
(new Object(){
	public String getResult(IWorld world, Vector3d pos, String _command) {
		StringBuilder _result = new StringBuilder();
		if (world instanceof ServerWorld) {
			ICommandSource _dataConsumer = new ICommandSource() {
				@Override public void sendMessage(ITextComponent message, UUID sender) {
					_result.append(message.getString());
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
			((ServerWorld) world).getServer().getCommandManager().handleCommand(new CommandSource(_dataConsumer, pos, Vector2f.ZERO, (ServerWorld) world, 4, "", new StringTextComponent(""), ((ServerWorld) world).getServer(), null), _command);
		}
		return _result.toString();
	}
}.getResult(world, new Vector3d(${input$x}, ${input$y}, ${input$z}), ${input$command}))
<#-- @formatter:on -->
