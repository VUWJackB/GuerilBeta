PImage originalImg;
PImage blurredImg;
PImage desaturatedImage;
PImage[] posterisedLayers;

int displayX, displayY;
int tempDisplayX, tempDisplayY;
float displayScale;

int dragStartX, dragStartY;

int blurValue;
int numLayers;
int[] thresholds;

Button loadButt;
Button saveButt;
Slider blurSlider;
Slider layersSlider;
MultibandSlider mbSlider;

void setup() {
    PImage icon = loadImage("data/icon.png");
    surface.setIcon(icon);
    size(1200, 800);
    frameRate(24);

    blurValue = 0;
    numLayers = 1;

    displayX = 202;
    displayY = 10;
    displayScale = 1;

    originalImg = createImage(0, 0, ARGB);
    blurredImg = createImage(0, 0, ARGB);
    desaturatedImage = createImage(0, 0, ARGB);
    posterisedLayers = new PImage[numLayers];
    for (int i = 0; i < numLayers; i++) {
        posterisedLayers[i] = createImage(0, 0, ARGB);
    }

    loadButt = new Button("New Stencil", buttonType.PRIMARY, 10, 10) {
        public void action() {
            selectInput("Select an image to load:", "fileSelected");
        }
    };

    saveButt = new Button("Save Layers", buttonType.PRIMARY, 10, 710) {
        public void action() {
            if (originalImg != null) exportLayers(posterisedLayers);
        }
    };

    blurSlider = new Slider(10, 100, 0, 10, 172);
    layersSlider = new Slider(10, 150, 1, 10, 172);
    mbSlider = new MultibandSlider(10, 200, 172, 500, 0, 255, numLayers);

    thresholds = mbSlider.getValues();
}

void draw() {
    background(255);
    noStroke();

    updateStencil();

    for (PImage i : posterisedLayers) image(i, displayX, displayY, originalImg.width * displayScale, originalImg.height * displayScale);

    fill(#CED4DA);
    rect(0, 0, 192, height);

    loadButt.render();
    saveButt.render();

    blurSlider.render();
    layersSlider.render();
    mbSlider.render();

    fill(255);
    text("Smoothness", 96, 90);
    text("Layers #", 96, 140);
}

void updateStencil() {
    if (blurSlider.getValue() != blurValue) {
        blurValue = blurSlider.getValue();
        updateBlur();
        updatePosterisation();
    }

    if (layersSlider.getValue() != numLayers) {
        numLayers = layersSlider.getValue();
        mbSlider.setBands(numLayers);
        thresholds = mbSlider.getValues();
        updatePosterisation();
    }

    for (int i = 0; i < numLayers; i++) {
        if (thresholds[i] != mbSlider.getValue(i)) {
            thresholds[i] = mbSlider.getValue(i);
            updatePosterisation();
        }
    }
}

void updateBlur() {
    blurredImg = originalImg.get();
    blurredImg.filter(BLUR, blurValue);
    desaturatedImage = desaturate(blurredImg);
}

void updatePosterisation() {
    posterisedLayers = posterise(desaturatedImage);
}

void fileSelected(File selection) {
    if (selection == null) {
        println("Window was closed or the user hit cancel.");
    } else {
        String path = selection.getAbsolutePath();
        String pathLower = path.toLowerCase();
        if (pathLower.endsWith(".png")
        || pathLower.endsWith(".jpg")
        || pathLower.endsWith(".jpeg")
        || pathLower.endsWith(".gif")
        || pathLower.endsWith(".tga")) {
            originalImg = loadImage(selection.getAbsolutePath());
            blurredImg = originalImg.get();
            blurredImg.filter(BLUR, blurValue);
            desaturatedImage = desaturate(blurredImg);
            posterisedLayers = posterise(desaturatedImage);
        }
    }
}

void mouseClicked() {
    loadButt.click();
    saveButt.click();
}

void mousePressed() {
    if (mouseX > 202) {
        tempDisplayX = displayX;
        tempDisplayY = displayY;
        dragStartX = mouseX;
        dragStartY = mouseY;
    }
}

void mouseDragged() {
    mbSlider.slide();
    blurSlider.slide();
    layersSlider.slide();

    if (mouseX > 202) {
        displayX = mouseX - dragStartX + tempDisplayX;
        displayY = mouseY - dragStartY + tempDisplayY;
    }
}


void mouseWheel(MouseEvent event) {
    if (mouseX > 202) displayScale += event.getCount() * -0.007;
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
    if (img == null) return layers;

    int[] mbValues = mbSlider.getValues();
    int[] mbColors = mbSlider.getColors();

    for (int i = 0; i < numLayers; i++) layers[i] = createImage(img.width, img.height, ARGB);

    int[] imgPixels = img.pixels; // Store image pixels array
    for (int i = 0; i < img.pixels.length; i++) {
        int lum = (imgPixels[i] >> 16) & 0xFF;
        for (int b = 0; b < numLayers; b++) {
            if (lum < mbSlider.getValues()[b]) {
                int bandColor = mbSlider.getColors()[b];
                layers[b].pixels[i] = color(bandColor, bandColor, bandColor, (alpha(img.pixels[i]) > 0) ? 255 : 0);
                break;
            } else {
                layers[b].pixels[i] = color(0, 0, 0, 0);
            }
        }
    }

    return layers;
}

void exportLayers(PImage[] layers) {
    if (layers[0] == null) return;
    if (layers[0].width == 0) return;
    if (layers[0].height == 0) return;
    for (int i = 0; i < layers.length; i++) {
        PGraphics output = createGraphics(layers[0].width, layers[0].height);
        output.beginDraw();
        output.background(0, 0); // Set the background with 0 alpha (fully transparent)
        output.image(layers[i], 0, 0); // Draw your image onto the PGraphics
        output.endDraw();
        output.save("Layer_" + i + ".png");
    }
}