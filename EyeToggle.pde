public class EyeToggle {
    private int xPos;
    private int yPos;
    private float size;

    private boolean open;

    public EyeToggle(int x, int y, int size) {
        this.xPos = x;
        this.yPos = y;
        this.size = size;

        this.open = true;
    }

    public void setY(int y) {
        this.yPos = y;
    }

    public boolean getState() {
        return this.open;
    }

    public void render() {
        if (this.open) {
            if (mouseX > this.xPos && mouseX < this.xPos + this.size * 2 && mouseY > this.yPos && mouseY < this.yPos + this.size) stroke(color(69, 130, 236));
            else stroke(255);
            strokeWeight(5);
            noFill();
            arc(this.xPos + this.size, this.yPos + this.size / 2, this.size * 2, this.size, PI, PI * 2);
            noStroke();
            if (mouseX > this.xPos && mouseX < this.xPos + this.size * 2 && mouseY > this.yPos && mouseY < this.yPos + this.size) fill(color(69, 130, 236));
            else fill(255);
            ellipse(this.xPos + this.size, this.yPos + this.size / 2, this.size, this.size);
        } else {
            if (mouseX > this.xPos && mouseX < this.xPos + this.size * 2 && mouseY > this.yPos && mouseY < this.yPos + this.size) stroke(color(69, 130, 236));
            else stroke(255);
            strokeWeight(5);
            noFill();
            arc(this.xPos + this.size, this.yPos + this.size / 2, this.size * 2, this.size, 0, PI);
        }
    }

    public void toggle() {
        if (mouseX > this.xPos && mouseX < this.xPos + this.size * 2 && mouseY > this.yPos && mouseY < this.yPos + this.size) {
            this.open = !(this.open);
        }
    }
}