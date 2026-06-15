<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
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
/*
 *	MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

import java.text.DecimalFormat;

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT) public class ${JavaModName}Screens {

	@SubscribeEvent public static void clientLoad(FMLClientSetupEvent event) {
		event.enqueueWork(() -> {
		<#list guis as gui>
			ScreenManager.registerFactory(${JavaModName}Menus.${gui.getModElement().getRegistryNameUpper()}.get(), ${gui.getModElement().getName()}Screen::new);
		</#list>
		});
	}

	public interface ScreenAccessor {
		void updateMenuState(int elementType, String name, Object elementState);
	}

	public static class ForgeSlider extends AbstractSlider {
      protected ITextComponent prefix;
      protected ITextComponent suffix;

      protected double minValue;
      protected double maxValue;

      protected double stepSize;

      protected boolean drawString;

      private final DecimalFormat format;

      public ForgeSlider(int x, int y, int width, int height, ITextComponent prefix, ITextComponent suffix, double minValue, double maxValue, double currentValue, double stepSize, int precision, boolean drawString) {
        super(x, y, width, height, StringTextComponent.EMPTY, 0D);
        this.prefix = prefix;
        this.suffix = suffix;
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.stepSize = Math.abs(stepSize);
        this.value = this.snapToNearest((currentValue - minValue) / (maxValue - minValue));
        this.drawString = drawString;

        if (stepSize == 0D) {
          precision = Math.min(precision, 4);

          StringBuilder builder = new StringBuilder("0");

          if (precision > 0)
            builder.append('.');

          while (precision--> 0)
            builder.append('0');

          this.format = new DecimalFormat(builder.toString());
        } else if (MathHelper.epsilonEquals(this.stepSize, Math.floor(this.stepSize))) {
          this.format = new DecimalFormat("0");
        } else {
          this.format = new DecimalFormat(Double.toString(this.stepSize).replaceAll("\\d", "0"));
        }

        this.updateMessage();
      }

      public ForgeSlider(int x, int y, int width, int height, ITextComponent prefix, ITextComponent suffix, double minValue, double maxValue, double currentValue, boolean drawString) {
        this(x, y, width, height, prefix, suffix, minValue, maxValue, currentValue, 1D, 0, drawString);
      }

      public double getValue() {
        return this.value * (maxValue - minValue) + minValue;
      }

      public long getValueLong() {
        return Math.round(this.getValue());
      }

      public int getValueInt() {
        return (int) this.getValueLong();
      }

      public void setValue(double value) {
        this.value = this.snapToNearest((value - this.minValue) / (this.maxValue - this.minValue));
        this.updateMessage();
      }

      public String getValueString() {
        return this.format.format(this.getValue());
      }

      @Override
      public void onClick(double mouseX, double mouseY) {
        this.setValueFromMouse(mouseX);
      }

      @Override
      protected void onDrag(double mouseX, double mouseY, double dragX, double dragY) {
        super.onDrag(mouseX, mouseY, dragX, dragY);
        this.setValueFromMouse(mouseX);
      }

      @Override
      public boolean keyPressed(int keyCode, int scanCode, int modifiers) {
        boolean flag = keyCode == GLFW.GLFW_KEY_LEFT;
        if (flag || keyCode == GLFW.GLFW_KEY_RIGHT) {
          if (this.minValue > this.maxValue)
            flag = !flag;
          float f = flag ? -1F : 1F;
          if (stepSize <= 0D)
            this.setSliderValue(this.value + (f / (this.width - 8)));
          else
            this.setValue(this.getValue() + f * this.stepSize);
        }

        return false;
      }

      private void setValueFromMouse(double mouseX) {
        this.setSliderValue((mouseX - (this.x + 4)) / (this.width - 8));
      }

      private void setSliderValue(double value) {
        double oldValue = this.value;
        this.value = this.snapToNearest(value);
        if (!MathHelper.epsilonEquals(oldValue, this.value))
          this.applyValue();

        this.updateMessage();
      }

      private double snapToNearest(double value) {
        if (stepSize <= 0D)
          return MathHelper.clamp(value, 0D, 1D);

        value = MathHelper.lerp(MathHelper.clamp(value, 0D, 1D), this.minValue, this.maxValue);

        value = (stepSize * Math.round(value / stepSize));

        if (this.minValue > this.maxValue) {
          value = MathHelper.clamp(value, this.maxValue, this.minValue);
        } else {
          value = MathHelper.clamp(value, this.minValue, this.maxValue);
        }

        return MathHelper.map(value, this.minValue, this.maxValue, 0D, 1D);
      }

      @Override
      protected void updateMessage() {
        if (this.drawString) {
          this.setMessage(new StringTextComponent("").appendSibling(prefix).appendText(this.getValueString()).appendSibling(suffix));
        } else {
          this.setMessage(StringTextComponent.EMPTY);
        }
      }

      @Override
      protected void applyValue() {}
    }
}
<#-- @formatter:on -->