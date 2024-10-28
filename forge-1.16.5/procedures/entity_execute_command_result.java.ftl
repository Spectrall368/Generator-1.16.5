<#-- @formatter:off -->
(new Object(){
	public String getResult(Entity _ent, String _command) {
		StringBuilder _result = new StringBuilder();
		if(!_ent.world.isRemote() && _ent.getServer() != null) {
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
			_ent.getServer().getCommandManager().handleCommand(new CommandSource(
					_dataConsumer, _ent.getPositionVec(), _ent.getPitchYaw(),
					_ent.world instanceof ServerWorld ? (ServerWorld) _ent.world : null, 4,
					_ent.getName().getString(), _ent.getDisplayName(), _ent.world.getServer(), _ent
			), _command);
		}
		return _result.toString();
	}
}.getResult(${input$entity}, ${input$command}))
<#-- @formatter:on -->
