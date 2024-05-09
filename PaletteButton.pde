import java.awt.Color;
import javax.swing.JColorChooser;

public class PalletteButton {
    int x;
    int y;

    PImage pallete;

    color layerColor;

    public PalletteButton(int xPos, int yPos, color layerColor) {
        this.x = xPos;
        this.y = yPos;

        this.pallete = loadImage("palette_white.png");
        this.layerColor = layerColor;
    }

    public void setY(int newY) {
        this.y = newY;
    }

    public void setColor(color newColor) {
        this.layerColor = newColor;
    }

    public color getColor() {
        return this.layerColor;
    }

    public void render() {
        tint(255);
        if (mouseX > this.x && mouseX < this.x + 20 && mouseY > this.y && mouseY < this.y + 20) {
            tint(69, 130, 236);
        }
        image(this.pallete, this.x, this.y, 20, 12);
        tint(255);
    }

    public boolean click() {
        if (mouseX > this.x && mouseX < this.x + 20 && mouseY > this.y && mouseY < this.y + 20) {
            Color pickedColor = JColorChooser.showDialog(null, "Layer Color", Color.black);
            if (pickedColor == null) return false;
            color newColor = color(pickedColor.getRed(), pickedColor.getGreen(), pickedColor.getBlue());
            this.layerColor = newColor;
            return true;
        }
        return false;
    }
}