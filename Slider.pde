public class Slider {
    private int min;
    private int max;

    private int xPos;
    private int yPos;

    private int sWidth;

    private int sliderPos;

    public Slider(int x, int y, int minValue, int maxValue, int sliderWidth) {
        this.min = minValue;
        this.max = maxValue;
        this.sWidth = sliderWidth;
        this.xPos = x;
        this.yPos = y;

        this.sliderPos = 0;
    }

    public int getValue() {
        return (int) map(this.sliderPos, 0, sWidth - 5, this.min, this.max);
    }

    public void slide() {
        if (mouseX > this.xPos && mouseX < this.xPos + this.sWidth && mouseY > this.yPos - 5 && mouseY < this.yPos + 15) {
            this.sliderPos = constrain(mouseX - this.xPos, 0, this.sWidth - 5);
        }
    }

    public void render() {
        noStroke();
        fill(color(69, 130, 236));
        rect(this.xPos, this.yPos, this.sWidth, 10);
        if (mouseX > this.xPos && mouseX < this.xPos + this.sWidth && mouseY > this.yPos - 5 && mouseY < this.yPos + 15) {
            fill(color(59, 111, 201));
        } else {
            fill(color(69, 130, 236));
        }
        circle(this.xPos + this.sliderPos + 5, this.yPos + 5, 20);
    }
}