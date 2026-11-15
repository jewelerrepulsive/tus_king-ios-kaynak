# TUS King iOS

TUS King web uygulamasının iPhone ve iPad için SwiftUI arayüz prototipi.
Uygulama kendi yerel ekranlarını kullanır ve web sayfası yüklemez.

## Xcode ile aç

1. `TUSKing.xcodeproj` dosyasını Xcode'da aç.
2. **TUSKing** şemasını ve bir iPhone veya iPad simülatörünü seç.
3. **Run**'a bas. Hedef iOS/iPadOS 16 veya üstüdür.

## Bu prototip

- 30 örnek kart, branş arama ve konu listesi.
- Kartı açma, cevabı gösterme, dört yanıt seçeneği ve turu sürdürme.
- Tekrar seçimi kartı turun sonuna ekler. Son yanıt bir kez geri alınabilir.
- Tur ve geri alma bilgisi uygulamanın kendi alanında kaydedilir.

## Katkı için sıradaki işler

- [ ] .apkg içe aktarma: ZIP, SQLite, alt desteler, etiketler ve medya.
- [ ] Tam alt deste ağacı ve etiket filtreleri.
- [ ] FSRS tekrar planı ve deste güncelleme sırasında ilerleme taşıma.
- [ ] Xcode derleme doğrulaması, iPhone/iPad simülatör testleri ve cihaz testleri.
- [ ] Kamusal depo açılmadan önce Swift kaynakları için lisans seçimi.

Web uygulamasının kayıtları iOS prototipine taşınmaz. Bu paket App Store
yayını içermez. Örnek kartların atıf ve kullanım şartları web projesindeki
deste ile aynıdır. Kart verisi ve Swift kaynakları için lisansları ayrı değerlendirin.

Örnek kart kaynağı: [TUS King](https://github.com/jewelerrepulsive/tus_king),
v1.3. Kartlar düz metin olarak gösterim için uyarlanmıştır.
Kart verisi [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)
koşullarıyla paylaşılır. Bu koşullar Swift kaynakları için bir lisans seçimi değildir.
