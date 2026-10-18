This window has a red blob in it.  You'll have to take my word for it.

![](screenshots/ch01_InSetup.png){width=3.6in}

```java
void setup() {
  size(800, 600);
  myBlob = new Blob(this, 400, 300, 40, color(255, 80, 80));
  myBlob.drawSprite();
}
```
