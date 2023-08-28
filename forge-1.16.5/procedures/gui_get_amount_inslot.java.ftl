(new Object(){
	public int getAmount(int sltid) {
			if(${input$entity} instanceof PlayerEntity) {
				Container _current = ((PlayerEntity) ${input$entity}).openContainer;
				if(_current instanceof Supplier) {
					Object invobj = ((Supplier) _current).get();
					if(invobj instanceof Map) {
						ItemStack stack = ((Slot) ((Map) invobj).get(sltid)).getStack();;
						if(stack != null)
							return stack.getCount();
					}
				}
			}
			return 0;
		}
}.getAmount((int)(${input$slotid})))
