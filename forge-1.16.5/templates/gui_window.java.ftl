<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2020 Pylo and contributors
 # 
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 # 
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 # 
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 # 
 # Additional permission for code generator templates (*.ftl files)
 # 
 # As a special exception, you may create a larger work that contains part or 
 # all of the MCreator code generator templates (*.ftl files) and distribute 
 # that work under terms of your choice, so long as that work isn't itself a 
 # template for code generation. Alternatively, if you modify or redistribute 
 # the template itself, you may (at your option) remove this special exception, 
 # which will cause the template and the resulting code generator output files 
 # to be licensed under the GNU General Public License without this special 
 # exception.
-->

<#-- @formatter:off -->
<#include "procedures.java.ftl">

<#assign mx = data.W - data.width>
<#assign my = data.H - data.height>

package ${package}.gui;

import ${package}.${JavaModName};

@OnlyIn(Dist.CLIENT) public class ${name}GuiWindow extends ContainerScreen<${name}Gui.GuiContainerMod> {

	private World world;
	private int x, y, z;
	private PlayerEntity entity;

	private final static HashMap guistate = ${name}Gui.guistate;

	<#list data.getComponentsOfType("TextField") as component>
	    TextFieldWidget ${component.getName()};
	</#list>

	<#list data.getComponentsOfType("Checkbox") as component>
	    CheckboxButton ${component.getName()};
	</#list>

	<#list data.getComponentsOfType("Button") as component>
		Button ${component.getName()};
	</#list>

	<#list data.getComponentsOfType("ImageButton") as component>
		ImageButton ${component.getName()};
	</#list>

	public ${name}GuiWindow(${name}Gui.GuiContainerMod container, PlayerInventory inventory, ITextComponent text) {
		super(container, inventory, text);
		this.world = container.world;
		this.x = container.x;
		this.y = container.y;
		this.z = container.z;
		this.entity = container.entity;
		this.xSize = ${data.width};
		this.ySize = ${data.height};
	}

	<#if data.doesPauseGame>
	@Override public boolean isPauseScreen() {
		return true;
	}
	</#if>

	<#if data.renderBgLayer>
	private static final ResourceLocation texture = new ResourceLocation("${modid}:textures/screens/${registryname}.png" );
	</#if>

	@Override public void render(MatrixStack ms, int mouseX, int mouseY, float partialTicks) {
		this.renderBackground(ms);
		super.render(ms, mouseX, mouseY, partialTicks);
		this.renderHoveredTooltip(ms, mouseX, mouseY);

		<#list data.getComponentsOfType("TextField") as component>
				${component.getName()}.render(ms, mouseX, mouseY, partialTicks);
		</#list>

		<#list data.getComponentsOfType("EntityModel") as component>
			<#assign followMouse = component.followMouseMovement>
			<#assign x = (component.x - mx/2)?int>
			<#assign y = (component.y - my/2)?int>
			if (<@procedureOBJToConditionCode component.entityModel/> instanceof LivingEntity) {
				<#if hasProcedure(component.displayCondition)>
					if (<@procedureOBJToConditionCode component.displayCondition/>)
				</#if>
				InventoryScreen.drawEntityOnScreen(this.guiLeft + ${x + 11}, this.guiTop + ${y + 21}, ${component.scale},
					${component.rotationX / 20.0}f <#if followMouse> + (float) Math.atan((this.guiLeft + ${x + 11} - mouseX) / 40.0)</#if>,
					<#if followMouse>(float) Math.atan((this.guiTop + ${y + 21 - 50} - mouseY) / 40.0)<#else>0</#if>,
					((LivingEntity) <@procedureOBJToConditionCode component.entityModel/>)
				);
			}
		</#list>
	}

	@Override protected void drawGuiContainerBackgroundLayer(MatrixStack ms, float partialTicks, int gx, int gy) {
		RenderSystem.color4f(1, 1, 1, 1);
		RenderSystem.enableBlend();
		RenderSystem.defaultBlendFunc();

		<#if data.renderBgLayer>
		Minecraft.getInstance().getTextureManager().bindTexture(texture);
		int k = (this.width - this.xSize) / 2;
		int l = (this.height - this.ySize) / 2;
		this.blit(ms, k, l, 0, 0, this.xSize, this.ySize, this.xSize, this.ySize);
		</#if>

		<#list data.getComponentsOfType("Image") as component>
			<#if hasProcedure(component.displayCondition)>if (<@procedureOBJToConditionCode component.displayCondition/>) {</#if>
				Minecraft.getInstance().getTextureManager().bindTexture(new ResourceLocation("${modid}:textures/screens/${component.image}"));
				this.blit(ms, this.guiLeft + ${(component.x - mx/2)?int}, this.guiTop + ${(component.y - my/2)?int}, 0, 0,
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())});
			<#if hasProcedure(component.displayCondition)>}</#if>
		</#list>

		RenderSystem.disableBlend();
	}

	@Override public boolean keyPressed(int key, int b, int c) {
		if (key == 256) {
			this.minecraft.player.closeScreen();
			return true;
		}

		<#list data.getComponentsOfType("TextField") as component>
		    if(${component.getName()}.isFocused())
		    	return ${component.getName()}.keyPressed(key, b, c);
		</#list>

		return super.keyPressed(key, b, c);
	}

	@Override public void tick() {
		super.tick();
		<#list data.getComponentsOfType("TextField") as component>
				${component.getName()}.tick();
		</#list>
	}

	@Override protected void drawGuiContainerForegroundLayer(MatrixStack ms, int mouseX, int mouseY) {
		<#list data.getComponentsOfType("Label") as component>
			<#if hasProcedure(component.displayCondition)>
			if (<@procedureOBJToConditionCode component.displayCondition/>)
			</#if>
			this.font.drawString(ms,
				<#if hasProcedure(component.text)><@procedureOBJToStringCode component.text/><#else>new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}").getString()</#if>,
				${(component.x - mx / 2)?int}, ${(component.y - my / 2)?int}, ${component.color.getRGB()});
		</#list>
	}

	@Override public void onClose() {
		super.onClose();
		Minecraft.getInstance().keyboardListener.enableRepeatEvents(false);
	}

	@Override public void init(Minecraft minecraft, int width, int height) {
		super.init(minecraft, width, height);
		minecraft.keyboardListener.enableRepeatEvents(true);

		<#list data.getComponentsOfType("TextField") as component>
			${component.getName()} = new TextFieldWidget(this.font, this.guiLeft + ${(component.x - mx/2)?int}, this.guiTop + ${(component.y - my/2)?int},
			${component.width}, ${component.height}, new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}"))
			<#if component.placeholder?has_content>
			{
				{
					setSuggestion(new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}").getString());
				}

				@Override public void writeText(String text) {
					super.writeText(text);

					if (getText().isEmpty())
						setSuggestion(new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}").getString());
					else
						setSuggestion(null);
				}

				@Override public void setCursorPosition(int pos) {
					super.setCursorPosition(pos);

					if (getText().isEmpty())
						setSuggestion(new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}").getString());
					else
						setSuggestion(null);
				}
			}
			</#if>;
			${component.getName()}.setMaxStringLength(32767);

        	guistate.put("text:${component.getName()}", ${component.getName()});
			this.children.add(this.${component.getName()});
		</#list>

		<#assign btid = 0>
		<#list data.getComponentsOfType("Button") as component>
			${component.getName()} = new Button(
				this.guiLeft + ${(component.x - mx/2)?int}, this.guiTop + ${(component.y - my/2)?int},
				${component.width}, ${component.height},
				new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}"),
				<@buttonOnClick component/>
			)<@buttonDisplayCondition component/>;

			${name}Gui.guistate.put("button:${component.getName()}", ${component.getName()});
			this.addButton(${component.getName()});

			<#assign btid +=1>
		</#list>

		<#list data.getComponentsOfType("ImageButton") as component>
			${component.getName()} = new ImageButton(
				this.guiLeft + ${(component.x - mx/2)?int}, this.guiTop + ${(component.y - my/2)?int},
				${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
				0, 0, ${component.getHeight(w.getWorkspace())},
				new ResourceLocation("${modid}:textures/screens/atlas/${component.getName()}.png"),
				${component.getWidth(w.getWorkspace())},
				${component.getHeight(w.getWorkspace()) * 2},
				<@buttonOnClick component/>
			)<@buttonDisplayCondition component/>;

			${name}Gui.guistate.put("button:${component.getName()}", ${component.getName()});
			this.addButton(${component.getName()});

			<#assign btid +=1>
		</#list>

		<#list data.getComponentsOfType("Checkbox") as component>
        	${component.getName()} = new CheckboxButton(this.guiLeft + ${(component.x - mx/2)?int}, this.guiTop + ${(component.y - my/2)?int},
            	    20, 20, new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}"), <#if hasProcedure(component.isCheckedProcedure)>
        	    <@procedureOBJToConditionCode component.isCheckedProcedure/><#else>false</#if>);

        	${name}Gui.guistate.put("checkbox:${component.getName()}", ${component.getName()});
        	this.addButton(${component.getName()});
		</#list>
	}

}
<#macro buttonOnClick component>
e -> {
	<#if hasProcedure(component.onClick)>
	    if (<@procedureOBJToConditionCode component.displayCondition/>) {
			${JavaModName}.PACKET_HANDLER.sendToServer(new ${name}Gui.ButtonPressedMessage(${btid}, x, y, z));
			${name}Gui.handleButtonAction(entity, ${btid}, x, y, z);
		}
	</#if>
}
</#macro>

<#macro buttonDisplayCondition component>
<#if hasProcedure(component.displayCondition)>
{
	@Override public void render(MatrixStack ms, int gx, int gy, float ticks) {
		if (<@procedureOBJToConditionCode component.displayCondition/>)
			super.render(ms, gx, gy, ticks);
	}
}
</#if>
</#macro>
<#-- @formatter:on -->
