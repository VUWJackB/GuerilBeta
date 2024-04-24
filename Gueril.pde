PImage originalImg;
PImage blurredImg;
PImage processedImg;

int blurValue;

Button testButt;
Slider blurSlider;
Slider thresholdSlider;

void setup() {
    blurValue = 0;

    size(1200, 800);
    testButt = new Button("New Stencil", buttonType.PRIMARY, 10, 10) {
        public void action() {
            selectInput("Select an image to load:", "fileSelected");
        }
    };
    blurSlider = new Slider(10, 100, 0, 10, 172);
    thresholdSlider = new Slider(10, 150, 0, 255, 172);
}

void draw() {
    background(255);
    noStroke();
    if (originalImg != null) {
        if (blurSlider.getValue() != blurValue) {
            blurValue = blurSlider.getValue();
            blurredImg = originalImg.get();
            blurredImg.filter(BLUR, blurValue);
            //println("updating blur");
        }
        image(posterise(desaturate(blurredImg), 1), 202, 10, originalImg.width, originalImg.height);
    }

    fill(#CED4DA);
    rect(0, 0, 192, height);
    testButt.render();
    blurSlider.render();
    thresholdSlider.render();
}

void fileSelected(File selection) {
    if (selection == null) {
        println("Window was closed or the user hit cancel.");
    } else {
        originalImg = loadImage(selection.getAbsolutePath());
        blurredImg = originalImg.get();
    }
}


void mouseClicked() {
    testButt.click();
}

void mouseDragged() {
    blurSlider.slide();
    thresholdSlider.slide();
}

PImage desaturate(PImage img) {
    PImage result = createImage(img.width, img.height, ARGB);

    for (int i = 0; i < img.pixels.length; i++) {
        float r = red(img.pixels[i]);
        float g = green(img.pixels[i]);
        float b = blue(img.pixels[i]);
        float lum = 0.2126 * r + 0.7152 * g + 0.0722 * b;
        result.pixels[i] = color(lum, lum, lum, alpha(img.pixels[i]));
    }

    return result;
}

PImage posterise(PImage img, int levels) {
    PImage result = createImage(img.width, img.height, ARGB);

    for (int i = 0; i < img.pixels.length; i++) {
        float lum = red(img.pixels[i]);
        if (lum < thresholdSlider.getValue()) {
            result.pixels[i] = color(0, 0, 0, alpha(img.pixels[i]) > 0 ? 255 : 0);
        } else {
            result.pixels[i] = color(200, 200, 200, alpha(img.pixels[i]) > 0 ? 255 : 0);
        }
    }

    return result;
}