PImage originalImg;
PImage blurredImg;
PImage desaturatedImage;
PImage[] posterisedLayers;
PImage processedImg;

int blurValue;
int numLayers;

Button testButt;
Slider blurSlider;
Slider layersSlider;
MultibandSlider mbSlider;

boolean imageLoaded = true;

void setup() {
    blurValue = 0;
    numLayers = 1;

    size(1200, 800);
    frameRate(24);
    testButt = new Button("New Stencil", buttonType.PRIMARY, 10, 10) {
        public void action() {
            selectInput("Select an image to load:", "fileSelected");
        }
    };
    blurSlider = new Slider(10, 100, 0, 10, 172);
    layersSlider = new Slider(10, 150, 1, 10, 172);
    mbSlider = new MultibandSlider(10, 200, 172, 500, 0, 255, numLayers);
}

void draw() {
    background(255);
    noStroke();
    if (originalImg != null) {
        if (blurSlider.getValue() != blurValue) {
            updateBlur();
        }
        for (PImage i : posterise(desaturatedImage)) {
            image(i, 202, 10, originalImg.width, originalImg.height);
        }
    }

    if (layersSlider.getValue() != numLayers) {
        numLayers = layersSlider.getValue();
        mbSlider.setBands(numLayers);
    }

    fill(#CED4DA);
    rect(0, 0, 192, height);
    testButt.render();
    blurSlider.render();

    layersSlider.render();

    mbSlider.render();
}

void updateBlur() {
    blurValue = blurSlider.getValue();
    blurredImg = originalImg.get();
    blurredImg.filter(BLUR, blurValue);
    desaturatedImage = desaturate(blurredImg).get();
}

void fileSelected(File selection) {
    if (selection == null) {
        println("Window was closed or the user hit cancel.");
    } else {
        originalImg = loadImage(selection.getAbsolutePath());
        blurredImg = originalImg.get();
        desaturatedImage = blurredImg.get();

    }
}


void mouseClicked() {
    testButt.click();
}

void mouseDragged() {
    mbSlider.slide();
    blurSlider.slide();
    layersSlider.slide();
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

PImage[] posterise(PImage img) {
    PImage[] layers = new PImage[numLayers];
    for (int j = 0; j < numLayers; j++) {
        PImage result = createImage(img.width, img.height, ARGB);
        for (int i = 0; i < img.pixels.length; i++) {
            float lum = red(img.pixels[i]);
            if (j == 0) {
                if (lum <= mbSlider.getValues()[j]) {
                    result.pixels[i] = color(mbSlider.getColors()[j], mbSlider.getColors()[j], mbSlider.getColors()[j], alpha(img.pixels[i]) > 0 ? 255 : 0);
                } else {
                    result.pixels[i] = color(0, 0, 0, 0);
                }
            } else {
                if (lum <= mbSlider.getValues()[j] && lum > mbSlider.getValues()[j - 1]) {
                    result.pixels[i] = color(mbSlider.getColors()[j], mbSlider.getColors()[j], mbSlider.getColors()[j], alpha(img.pixels[i]) > 0 ? 255 : 0);
                } else {
                    result.pixels[i] = color(0, 0, 0, 0);
                }
            }
        }
        layers[j] = result.get();
    }

    return layers;
}