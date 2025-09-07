import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @homePage.
  ///
  /// In en, this message translates to:
  /// **'Ana Sayfa'**
  String get homePage;

  /// No description provided for @adhkar.
  ///
  /// In en, this message translates to:
  /// **'Zikirler'**
  String get adhkar;

  /// No description provided for @quran.
  ///
  /// In en, this message translates to:
  /// **'Kur’anı-ı Kerim'**
  String get quran;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Şubeler'**
  String get branches;

  /// No description provided for @myFile.
  ///
  /// In en, this message translates to:
  /// **'Dosyam'**
  String get myFile;

  /// No description provided for @outdated_version_message.
  ///
  /// In en, this message translates to:
  /// **'Kullandığınız sürüm eski. Lütfen güncellemek için süpervizörle iletişime geçin.'**
  String get outdated_version_message;

  /// No description provided for @exit_application_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Uygulamadan çıkmak istediğinizden emin misiniz?'**
  String get exit_application_confirmation;

  /// No description provided for @account_registration_approved.
  ///
  /// In en, this message translates to:
  /// **'Hedayi platformunda hesap kaydınız onaylandı.'**
  String get account_registration_approved;

  /// No description provided for @image_size_exceeded.
  ///
  /// In en, this message translates to:
  /// **'Seçilen resim maksimum dosya boyutunu (2 MB) aşıyor. Lütfen daha küçük bir resim seçin.'**
  String get image_size_exceeded;

  /// No description provided for @image_size_exceeded_message.
  ///
  /// In en, this message translates to:
  /// **'Seçilen resim maksimum dosya boyutunu (2 MB) aşıyor. Lütfen daha küçük bir resim seçin.'**
  String get image_size_exceeded_message;

  /// No description provided for @leave_page_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Bu sayfadan ayrılmak istediğinizden emin misiniz?'**
  String get leave_page_confirmation;

  /// No description provided for @item_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Bu öğe zaten mevcut.'**
  String get item_already_exists;

  /// No description provided for @unexpected_error_message.
  ///
  /// In en, this message translates to:
  /// **'Beklenmeyen bir hata oluştu. Lütfen daha sonra tekrar deneyin.'**
  String get unexpected_error_message;

  /// No description provided for @unexpected_error_occurred.
  ///
  /// In en, this message translates to:
  /// **'Beklenmeyen bir hata oluştu. Lütfen daha sonra tekrar deneyin.'**
  String get unexpected_error_occurred;

  /// No description provided for @fields_required_message.
  ///
  /// In en, this message translates to:
  /// **'Öğeyi kaydetmek için yukarıdaki tüm alanlar doldurulmalıdır.'**
  String get fields_required_message;

  /// No description provided for @select_section_message.
  ///
  /// In en, this message translates to:
  /// **'Lütfen bir bölüm seçin.'**
  String get select_section_message;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Telefon'**
  String get phone;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Dil Seç'**
  String get chooseLanguage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Onayla'**
  String get confirm;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @option_not_available.
  ///
  /// In en, this message translates to:
  /// **'Birden fazla resim yüklendiğinde bu seçenek kullanılamaz.'**
  String get option_not_available;

  /// No description provided for @image_exceeds_the_maximum_size.
  ///
  /// In en, this message translates to:
  /// **'Seçilen resim maksimum dosya boyutunu (2 MB) aşıyor. Lütfen daha küçük bir resim seçin.'**
  String get image_exceeds_the_maximum_size;

  /// No description provided for @question_exist_page.
  ///
  /// In en, this message translates to:
  /// **'Sayfadan çıkmak istediğinizden emin misiniz?'**
  String get question_exist_page;

  /// No description provided for @program_schedule.
  ///
  /// In en, this message translates to:
  /// **'+ Program takvimi ekle'**
  String get program_schedule;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Bugün'**
  String get today;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Kitaplar'**
  String get book;

  /// No description provided for @start_time.
  ///
  /// In en, this message translates to:
  /// **'Başlangıç zamanı'**
  String get start_time;

  /// No description provided for @end_time.
  ///
  /// In en, this message translates to:
  /// **'Bitiş zamanı'**
  String get end_time;

  /// No description provided for @operation_successfully.
  ///
  /// In en, this message translates to:
  /// **'İşlem başarıyla tamamlandı'**
  String get operation_successfully;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'Beklenmeyen bir hata oluştu. Lütfen daha sonra tekrar deneyin.'**
  String get unexpected_error;

  /// No description provided for @schedule_details_section.
  ///
  /// In en, this message translates to:
  /// **'Program detayları bölümü'**
  String get schedule_details_section;

  /// No description provided for @week_days.
  ///
  /// In en, this message translates to:
  /// **'Cumartesi'**
  String get week_days;

  /// No description provided for @week_days2.
  ///
  /// In en, this message translates to:
  /// **'Pazar'**
  String get week_days2;

  /// No description provided for @week_days3.
  ///
  /// In en, this message translates to:
  /// **'Pazartesi'**
  String get week_days3;

  /// No description provided for @week_days4.
  ///
  /// In en, this message translates to:
  /// **'Salı'**
  String get week_days4;

  /// No description provided for @week_days5.
  ///
  /// In en, this message translates to:
  /// **'Çarşamba'**
  String get week_days5;

  /// No description provided for @week_days6.
  ///
  /// In en, this message translates to:
  /// **'Perşembe'**
  String get week_days6;

  /// No description provided for @week_days7.
  ///
  /// In en, this message translates to:
  /// **'Cuma'**
  String get week_days7;

  /// No description provided for @number_of_rows.
  ///
  /// In en, this message translates to:
  /// **'Satır sayısı'**
  String get number_of_rows;

  /// No description provided for @approved_students_count.
  ///
  /// In en, this message translates to:
  /// **'Onaylanan öğrenci sayısı'**
  String get approved_students_count;

  /// No description provided for @number_of_sections.
  ///
  /// In en, this message translates to:
  /// **'Bölüm sayısı'**
  String get number_of_sections;

  /// No description provided for @lessons_count.
  ///
  /// In en, this message translates to:
  /// **'Ders sayısı'**
  String get lessons_count;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Etkinlikler'**
  String get activities;

  /// No description provided for @no_results.
  ///
  /// In en, this message translates to:
  /// **'Sonuç yok'**
  String get no_results;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Ara'**
  String get search;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'İstatistikler'**
  String get statistics;

  /// No description provided for @teacher_not_in_center.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen bir merkeze ait değil'**
  String get teacher_not_in_center;

  /// No description provided for @edit_class.
  ///
  /// In en, this message translates to:
  /// **'Sınıfı düzenle'**
  String get edit_class;

  /// No description provided for @confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Bu öğeyi silmek istediğinizden emin misiniz?'**
  String get confirm_delete;

  /// No description provided for @add_class.
  ///
  /// In en, this message translates to:
  /// **'Sınıf ekle'**
  String get add_class;

  /// No description provided for @sections.
  ///
  /// In en, this message translates to:
  /// **'Bölümler'**
  String get sections;

  /// No description provided for @edit_students.
  ///
  /// In en, this message translates to:
  /// **'Öğrencileri düzenle'**
  String get edit_students;

  /// No description provided for @add_student.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci ekle'**
  String get add_student;

  /// No description provided for @operation_success.
  ///
  /// In en, this message translates to:
  /// **'İşlem başarılı'**
  String get operation_success;

  /// No description provided for @add_center_manager.
  ///
  /// In en, this message translates to:
  /// **'Merkez yöneticisi ekle +'**
  String get add_center_manager;

  /// No description provided for @confirm_delete3.
  ///
  /// In en, this message translates to:
  /// **'Bu öğeyi silmek istediğinizden emin misiniz?'**
  String get confirm_delete3;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Bekar'**
  String get single;

  /// No description provided for @married.
  ///
  /// In en, this message translates to:
  /// **'Evli'**
  String get married;

  /// No description provided for @widow.
  ///
  /// In en, this message translates to:
  /// **'Dul'**
  String get widow;

  /// No description provided for @edit_teacher.
  ///
  /// In en, this message translates to:
  /// **'Öğretmeni düzenle'**
  String get edit_teacher;

  /// No description provided for @add_teacher.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen ekle'**
  String get add_teacher;

  /// No description provided for @managers.
  ///
  /// In en, this message translates to:
  /// **'Yöneticiler'**
  String get managers;

  /// No description provided for @confirm_delete4.
  ///
  /// In en, this message translates to:
  /// **'Bu öğeyi silmek istediğinizden emin misiniz?'**
  String get confirm_delete4;

  /// No description provided for @add_manager.
  ///
  /// In en, this message translates to:
  /// **'Yönetici ekle'**
  String get add_manager;

  /// No description provided for @sections_awaiting_approval.
  ///
  /// In en, this message translates to:
  /// **'Onay bekleyen bölümler'**
  String get sections_awaiting_approval;

  /// No description provided for @people_awaiting_approval.
  ///
  /// In en, this message translates to:
  /// **'Onay bekleyen kişiler'**
  String get people_awaiting_approval;

  /// No description provided for @no_information_available.
  ///
  /// In en, this message translates to:
  /// **'Bilgi yok'**
  String get no_information_available;

  /// No description provided for @confirm_accept.
  ///
  /// In en, this message translates to:
  /// **'Bu öğeyi kabul etmek istediğinizden emin misiniz?'**
  String get confirm_accept;

  /// No description provided for @confirm_reject.
  ///
  /// In en, this message translates to:
  /// **'Bu öğeyi reddetmek istediğinizden emin misiniz?'**
  String get confirm_reject;

  /// No description provided for @section_information.
  ///
  /// In en, this message translates to:
  /// **'Bölüm bilgisi'**
  String get section_information;

  /// No description provided for @account_information.
  ///
  /// In en, this message translates to:
  /// **'Hesap bilgisi'**
  String get account_information;

  /// No description provided for @view_managers.
  ///
  /// In en, this message translates to:
  /// **'Yöneticileri görüntüle'**
  String get view_managers;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'Mevcut değil'**
  String get not_available;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Kullanıcı adı'**
  String get username;

  /// No description provided for @first_name_last_name.
  ///
  /// In en, this message translates to:
  /// **'Adı ve soyadı'**
  String get first_name_last_name;

  /// No description provided for @father_name.
  ///
  /// In en, this message translates to:
  /// **'Baba adı'**
  String get father_name;

  /// No description provided for @mother_name.
  ///
  /// In en, this message translates to:
  /// **'Anne adı'**
  String get mother_name;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Doğum tarihi'**
  String get date_of_birth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Cinsiyet'**
  String get gender;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Kadın'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Erkek'**
  String get male;

  /// No description provided for @student_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Öğrencinin telefon numarası'**
  String get student_phone_number;

  /// No description provided for @national_id_number.
  ///
  /// In en, this message translates to:
  /// **'Kimlik numarası'**
  String get national_id_number;

  /// No description provided for @place_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Doğum yeri'**
  String get place_of_birth;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Aktif değil'**
  String get inactive;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Aktif'**
  String get active;

  /// No description provided for @private_account_information.
  ///
  /// In en, this message translates to:
  /// **'Özel hesap bilgisi'**
  String get private_account_information;

  /// No description provided for @current_residence.
  ///
  /// In en, this message translates to:
  /// **'Güncel ikametgah'**
  String get current_residence;

  /// No description provided for @blood_type.
  ///
  /// In en, this message translates to:
  /// **'Kan grubu'**
  String get blood_type;

  /// No description provided for @chronic_illness_present.
  ///
  /// In en, this message translates to:
  /// **'Kronik hastalık var mı?'**
  String get chronic_illness_present;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Evet'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'Hayır'**
  String get no;

  /// No description provided for @illness_name.
  ///
  /// In en, this message translates to:
  /// **'Hastalık adı'**
  String get illness_name;

  /// No description provided for @treatment_available.
  ///
  /// In en, this message translates to:
  /// **'Tedavi oldu mu?'**
  String get treatment_available;

  /// No description provided for @treatment_name.
  ///
  /// In en, this message translates to:
  /// **'Tedavi adı'**
  String get treatment_name;

  /// No description provided for @family_chronic_illness.
  ///
  /// In en, this message translates to:
  /// **'Ailede kronik hastalık var mı?'**
  String get family_chronic_illness;

  /// No description provided for @is_chronic_illness.
  ///
  /// In en, this message translates to:
  /// **'Kronik hastalık var mı'**
  String get is_chronic_illness;

  /// No description provided for @person_information.
  ///
  /// In en, this message translates to:
  /// **'Kişi bilgisi'**
  String get person_information;

  /// No description provided for @click_for_details.
  ///
  /// In en, this message translates to:
  /// **'Detaylar için tıklayın'**
  String get click_for_details;

  /// No description provided for @types_of_activities.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik türleri'**
  String get types_of_activities;

  /// No description provided for @add_activity_type.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik türü ekle'**
  String get add_activity_type;

  /// No description provided for @edit_activity_type.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik türünü düzenle'**
  String get edit_activity_type;

  /// No description provided for @school.
  ///
  /// In en, this message translates to:
  /// **'Okul'**
  String get school;

  /// No description provided for @university.
  ///
  /// In en, this message translates to:
  /// **'Üniversite'**
  String get university;

  /// No description provided for @add_book.
  ///
  /// In en, this message translates to:
  /// **'Kitap ekle'**
  String get add_book;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Konular'**
  String get subjects;

  /// No description provided for @add_new_item.
  ///
  /// In en, this message translates to:
  /// **'+ Yeni öğe ekle'**
  String get add_new_item;

  /// No description provided for @add_subject.
  ///
  /// In en, this message translates to:
  /// **'Konu ekle'**
  String get add_subject;

  /// No description provided for @no_books_available.
  ///
  /// In en, this message translates to:
  /// **'Kitap yok'**
  String get no_books_available;

  /// No description provided for @edit_subject.
  ///
  /// In en, this message translates to:
  /// **'Konuyu düzenle'**
  String get edit_subject;

  /// No description provided for @search_filter_student.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci arama ve filtreleme'**
  String get search_filter_student;

  /// No description provided for @serial_number.
  ///
  /// In en, this message translates to:
  /// **'Sıra numarası'**
  String get serial_number;

  /// No description provided for @search_filter_teacher.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen arama ve filtreleme'**
  String get search_filter_teacher;

  /// No description provided for @student_not_in_center.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci bir merkeze ait değil'**
  String get student_not_in_center;

  /// No description provided for @regions.
  ///
  /// In en, this message translates to:
  /// **'Bölgeler'**
  String get regions;

  /// No description provided for @search_regions.
  ///
  /// In en, this message translates to:
  /// **'Bölgelerde ara'**
  String get search_regions;

  /// No description provided for @add_region.
  ///
  /// In en, this message translates to:
  /// **'Bölge ekle'**
  String get add_region;

  /// No description provided for @add_region_plus.
  ///
  /// In en, this message translates to:
  /// **'Bölge ekle +'**
  String get add_region_plus;

  /// No description provided for @no_data_available.
  ///
  /// In en, this message translates to:
  /// **'Veri yok'**
  String get no_data_available;

  /// No description provided for @login_required.
  ///
  /// In en, this message translates to:
  /// **'Bu sayfaya erişmek için giriş yapmalısınız'**
  String get login_required;

  /// No description provided for @edit_region.
  ///
  /// In en, this message translates to:
  /// **'Bölgeyi düzenle'**
  String get edit_region;

  /// No description provided for @browse_centers.
  ///
  /// In en, this message translates to:
  /// **'Merkezleri buradan görüntüleyebilirsiniz'**
  String get browse_centers;

  /// No description provided for @add_region_manager.
  ///
  /// In en, this message translates to:
  /// **'+ Bölge yöneticisi ekle'**
  String get add_region_manager;

  /// No description provided for @search_centers.
  ///
  /// In en, this message translates to:
  /// **'Merkezlerde ara'**
  String get search_centers;

  /// No description provided for @add_center.
  ///
  /// In en, this message translates to:
  /// **'Merkez ekle'**
  String get add_center;

  /// No description provided for @no_centers_available.
  ///
  /// In en, this message translates to:
  /// **'Merkez yok'**
  String get no_centers_available;

  /// No description provided for @edit_center.
  ///
  /// In en, this message translates to:
  /// **'Merkezi düzenle'**
  String get edit_center;

  /// No description provided for @welcome_hidaya_foundation.
  ///
  /// In en, this message translates to:
  /// **'Hidaya Vakfı\'na hoş geldiniz'**
  String get welcome_hidaya_foundation;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Şifre'**
  String get password;

  /// No description provided for @incorrect_username_password.
  ///
  /// In en, this message translates to:
  /// **'Kullanıcı adı veya şifre yanlış'**
  String get incorrect_username_password;

  /// No description provided for @enter_username_password.
  ///
  /// In en, this message translates to:
  /// **'Lütfen kullanıcı adınızı veya şifrenizi girin'**
  String get enter_username_password;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'Giriş yap'**
  String get log_in;

  /// No description provided for @upload_success_Quran.
  ///
  /// In en, this message translates to:
  /// **'Tüm Kur’anı-ı Kerim testleri başarıyla yüklendi'**
  String get upload_success_Quran;

  /// No description provided for @upload_success_lessons.
  ///
  /// In en, this message translates to:
  /// **'Tüm dersler başarıyla yüklendi'**
  String get upload_success_lessons;

  /// No description provided for @organization_name.
  ///
  /// In en, this message translates to:
  /// **'Anwar al-Huda Kur’anı-ı Kerim ve İlimleri Kurumu'**
  String get organization_name;

  /// No description provided for @organization_description.
  ///
  /// In en, this message translates to:
  /// **'Hidayet Nuru Çami Kur’an Kursları Programı'**
  String get organization_description;

  /// No description provided for @holy_quran.
  ///
  /// In en, this message translates to:
  /// **'Kur’anı-ı Kerim-ı Kerim'**
  String get holy_quran;

  /// No description provided for @surah.
  ///
  /// In en, this message translates to:
  /// **'Sure'**
  String get surah;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get name;

  /// No description provided for @activity_information.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik bilgisi'**
  String get activity_information;

  /// No description provided for @activity_name.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik adı'**
  String get activity_name;

  /// No description provided for @activity_description.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik açıklaması'**
  String get activity_description;

  /// No description provided for @activity_location.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik yeri'**
  String get activity_location;

  /// No description provided for @activity_date.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik tarihi'**
  String get activity_date;

  /// No description provided for @activity_cost.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik maliyeti'**
  String get activity_cost;

  /// No description provided for @activity_type.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik türü'**
  String get activity_type;

  /// No description provided for @present_students.
  ///
  /// In en, this message translates to:
  /// **'Katılan öğrenciler'**
  String get present_students;

  /// No description provided for @activity_teacher_supervisor.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik öğretmeni veya süpervizörü'**
  String get activity_teacher_supervisor;

  /// No description provided for @first_section.
  ///
  /// In en, this message translates to:
  /// **'Birinci bölüm'**
  String get first_section;

  /// No description provided for @personal_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Kişisel telefon numarası'**
  String get personal_phone_number;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'E-posta adresi'**
  String get email_address;

  /// No description provided for @manager_status.
  ///
  /// In en, this message translates to:
  /// **'Yönetici durumu'**
  String get manager_status;

  /// No description provided for @organization_manager.
  ///
  /// In en, this message translates to:
  /// **'Kurum yöneticisi'**
  String get organization_manager;

  /// No description provided for @center_manager.
  ///
  /// In en, this message translates to:
  /// **'Merkez yöneticisi'**
  String get center_manager;

  /// No description provided for @region_manager.
  ///
  /// In en, this message translates to:
  /// **'Bölge yöneticisi'**
  String get region_manager;

  /// No description provided for @general_manager.
  ///
  /// In en, this message translates to:
  /// **'Genel müdür'**
  String get general_manager;

  /// No description provided for @manager_type.
  ///
  /// In en, this message translates to:
  /// **'Yönetici türü'**
  String get manager_type;

  /// No description provided for @first_grade.
  ///
  /// In en, this message translates to:
  /// **'Birinci sınıf'**
  String get first_grade;

  /// No description provided for @center_name.
  ///
  /// In en, this message translates to:
  /// **'Merkez adı'**
  String get center_name;

  /// No description provided for @region_name.
  ///
  /// In en, this message translates to:
  /// **'Bölge adı'**
  String get region_name;

  /// No description provided for @marital_status.
  ///
  /// In en, this message translates to:
  /// **'Medeni hali'**
  String get marital_status;

  /// No description provided for @number_of_wives.
  ///
  /// In en, this message translates to:
  /// **'Eş sayısı'**
  String get number_of_wives;

  /// No description provided for @number_of_children.
  ///
  /// In en, this message translates to:
  /// **'Çocuk sayısı'**
  String get number_of_children;

  /// No description provided for @chronic_illness_home.
  ///
  /// In en, this message translates to:
  /// **'Ailede kronik hasta var mı??'**
  String get chronic_illness_home;

  /// No description provided for @edit_manager.
  ///
  /// In en, this message translates to:
  /// **'Yöneticiyi düzenle'**
  String get edit_manager;

  /// No description provided for @resident_teacher_name_id.
  ///
  /// In en, this message translates to:
  /// **'Öğretmenin adı ve kimlik numarası'**
  String get resident_teacher_name_id;

  /// No description provided for @total_evaluation.
  ///
  /// In en, this message translates to:
  /// **'Bu değerlendirmenin toplamı'**
  String get total_evaluation;

  /// No description provided for @added_on.
  ///
  /// In en, this message translates to:
  /// **'Eklendiği tarih'**
  String get added_on;

  /// No description provided for @from_time.
  ///
  /// In en, this message translates to:
  /// **'Başlangıç saati'**
  String get from_time;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'Bitiş saati'**
  String get to;

  /// No description provided for @chronic_illness.
  ///
  /// In en, this message translates to:
  /// **'Kronik hastalık?'**
  String get chronic_illness;

  /// No description provided for @section_name.
  ///
  /// In en, this message translates to:
  /// **'Bölüm adı'**
  String get section_name;

  /// No description provided for @grade_id.
  ///
  /// In en, this message translates to:
  /// **'Sınıf kimliği'**
  String get grade_id;

  /// No description provided for @grade_name.
  ///
  /// In en, this message translates to:
  /// **'Sınıf adı'**
  String get grade_name;

  /// No description provided for @center_id.
  ///
  /// In en, this message translates to:
  /// **'Merkez kimliği'**
  String get center_id;

  /// No description provided for @section_capacity.
  ///
  /// In en, this message translates to:
  /// **'Bölüm kapasitesi'**
  String get section_capacity;

  /// No description provided for @student_status.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci durumu'**
  String get student_status;

  /// No description provided for @book_information.
  ///
  /// In en, this message translates to:
  /// **'Kitap bilgisi'**
  String get book_information;

  /// No description provided for @book_name.
  ///
  /// In en, this message translates to:
  /// **'Kitap adı'**
  String get book_name;

  /// No description provided for @book_size.
  ///
  /// In en, this message translates to:
  /// **'Kitap boyutu'**
  String get book_size;

  /// No description provided for @cultural.
  ///
  /// In en, this message translates to:
  /// **'Kültürel'**
  String get cultural;

  /// No description provided for @methodological.
  ///
  /// In en, this message translates to:
  /// **'Yöntemsel'**
  String get methodological;

  /// No description provided for @book_author.
  ///
  /// In en, this message translates to:
  /// **'Kitap yazarı'**
  String get book_author;

  /// No description provided for @book_pages_count.
  ///
  /// In en, this message translates to:
  /// **'Kitap sayfa sayısı'**
  String get book_pages_count;

  /// No description provided for @center_type.
  ///
  /// In en, this message translates to:
  /// **'Merkez türü'**
  String get center_type;

  /// No description provided for @testSubject.
  ///
  /// In en, this message translates to:
  /// **'Test Konusu'**
  String get testSubject;

  /// No description provided for @testDate.
  ///
  /// In en, this message translates to:
  /// **'Test Tarihi'**
  String get testDate;

  /// No description provided for @testTime.
  ///
  /// In en, this message translates to:
  /// **'Test Saati'**
  String get testTime;

  /// No description provided for @testType.
  ///
  /// In en, this message translates to:
  /// **'Test Türü'**
  String get testType;

  /// No description provided for @informative.
  ///
  /// In en, this message translates to:
  /// **'Bilgilendirici'**
  String get informative;

  /// No description provided for @testResult.
  ///
  /// In en, this message translates to:
  /// **'Test Sonucu'**
  String get testResult;

  /// No description provided for @testInformation.
  ///
  /// In en, this message translates to:
  /// **'Test Bilgisi'**
  String get testInformation;

  /// No description provided for @interviewName.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Adı'**
  String get interviewName;

  /// No description provided for @interviewLocation.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Yeri'**
  String get interviewLocation;

  /// No description provided for @interviewDate.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Tarihi'**
  String get interviewDate;

  /// No description provided for @compensation.
  ///
  /// In en, this message translates to:
  /// **'Tazminat'**
  String get compensation;

  /// No description provided for @interviewType.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Türü'**
  String get interviewType;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'gol'**
  String get score;

  /// No description provided for @addSession.
  ///
  /// In en, this message translates to:
  /// **'Ders Ekle'**
  String get addSession;

  /// No description provided for @juz.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get juz;

  /// No description provided for @interviewScore.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Puanı'**
  String get interviewScore;

  /// No description provided for @studentName.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci Adı'**
  String get studentName;

  /// No description provided for @noteDate.
  ///
  /// In en, this message translates to:
  /// **'Not Tarihi'**
  String get noteDate;

  /// No description provided for @noteTime.
  ///
  /// In en, this message translates to:
  /// **'Not Saati'**
  String get noteTime;

  /// No description provided for @noteInformation.
  ///
  /// In en, this message translates to:
  /// **'Not Bilgisi'**
  String get noteInformation;

  /// No description provided for @verse.
  ///
  /// In en, this message translates to:
  /// **'Ayet'**
  String get verse;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Sayfa'**
  String get page;

  /// No description provided for @laboratory.
  ///
  /// In en, this message translates to:
  /// **'Laboratuvar'**
  String get laboratory;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Kaydedildi'**
  String get saved;

  /// No description provided for @readFromQuran.
  ///
  /// In en, this message translates to:
  /// **'Kur\'an\'dan oku'**
  String get readFromQuran;

  /// No description provided for @recitationInformation.
  ///
  /// In en, this message translates to:
  /// **'Okuma Bilgisi'**
  String get recitationInformation;

  /// No description provided for @teacherEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen Değerlendirmesi'**
  String get teacherEvaluation;

  /// No description provided for @teacherCount.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen sıra no'**
  String get teacherCount;

  /// No description provided for @teacherName.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen Adı'**
  String get teacherName;

  /// No description provided for @supervisor.
  ///
  /// In en, this message translates to:
  /// **'Danışman'**
  String get supervisor;

  /// No description provided for @visitTime.
  ///
  /// In en, this message translates to:
  /// **'Ziyaret Zamanı'**
  String get visitTime;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Tarih'**
  String get date;

  /// No description provided for @correctArabicReadingScoreOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Doğru Arapça Okuma Puanı 10 üzerinden'**
  String get correctArabicReadingScoreOutOf10;

  /// No description provided for @memorizationScoreOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Ezber Puanı 10 üzerinden'**
  String get memorizationScoreOutOf10;

  /// No description provided for @scientificLessonScoreOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Bilimsel Ders Puanı 10 üzerinden'**
  String get scientificLessonScoreOutOf10;

  /// No description provided for @individualFollowUpTimeScoreOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Bireysel Takip Zamanı Puanı 10 üzerinden'**
  String get individualFollowUpTimeScoreOutOf10;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Dersler'**
  String get lessons;

  /// No description provided for @adherenceToPlanScoreOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Plana Uyum Puanı 10 üzerinden'**
  String get adherenceToPlanScoreOutOf10;

  /// No description provided for @punctualityScoreOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Vakit Disiplini 10 üzerinden'**
  String get punctualityScoreOutOf10;

  /// No description provided for @studentDisciplineScoreOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Sınıf Yönetimi 10 üzerinden'**
  String get studentDisciplineScoreOutOf10;

  /// No description provided for @activitiesScoreOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Etkinlikler Puanı 10 üzerinden'**
  String get activitiesScoreOutOf10;

  /// No description provided for @administrativeDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Yönetmeliklere riayeti'**
  String get administrativeDiscipline;

  /// No description provided for @administrativeDisciplineScoreOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Yönetmeliklere riayeti Puanı 10 üzerinden'**
  String get administrativeDisciplineScoreOutOf10;

  /// No description provided for @tests.
  ///
  /// In en, this message translates to:
  /// **'Testler'**
  String get tests;

  /// No description provided for @testsAndStudyScoreOutOf10.
  ///
  /// In en, this message translates to:
  /// **'STS 10 üzerinden'**
  String get testsAndStudyScoreOutOf10;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Toplam'**
  String get total;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Yüzde'**
  String get percentage;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Özel Bilgiler'**
  String get notes;

  /// No description provided for @studentsCount.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci Sayısı'**
  String get studentsCount;

  /// No description provided for @lessonName.
  ///
  /// In en, this message translates to:
  /// **'Ders Adı'**
  String get lessonName;

  /// No description provided for @lessonDescription.
  ///
  /// In en, this message translates to:
  /// **'Ders Açıklaması'**
  String get lessonDescription;

  /// No description provided for @lessonLocation.
  ///
  /// In en, this message translates to:
  /// **'Ders Yeri'**
  String get lessonLocation;

  /// No description provided for @lessonType.
  ///
  /// In en, this message translates to:
  /// **'Ders Türü'**
  String get lessonType;

  /// No description provided for @lessonBook.
  ///
  /// In en, this message translates to:
  /// **'Ders Kitabı'**
  String get lessonBook;

  /// No description provided for @lessonTime.
  ///
  /// In en, this message translates to:
  /// **'Ders Zamanı'**
  String get lessonTime;

  /// No description provided for @lessonDate.
  ///
  /// In en, this message translates to:
  /// **'Ders Tarihi'**
  String get lessonDate;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Telefon Numarası'**
  String get phoneNumberLabel;

  /// No description provided for @parentPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Ebeveyn Telefon Numarası'**
  String get parentPhoneNumber;

  /// No description provided for @student_Center.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci Merkezi'**
  String get student_Center;

  /// No description provided for @studentGrade.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci Sınıfı'**
  String get studentGrade;

  /// No description provided for @sectionOrCircle.
  ///
  /// In en, this message translates to:
  /// **'Bölüm veya Halka'**
  String get sectionOrCircle;

  /// No description provided for @familyMembersCount.
  ///
  /// In en, this message translates to:
  /// **'Aile Üyesi Sayısı'**
  String get familyMembersCount;

  /// No description provided for @guardian.
  ///
  /// In en, this message translates to:
  /// **'Vasi'**
  String get guardian;

  /// No description provided for @isStudentOrphan.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci yetim mi?'**
  String get isStudentOrphan;

  /// No description provided for @interviewer.
  ///
  /// In en, this message translates to:
  /// **'Görüşmeci'**
  String get interviewer;

  /// No description provided for @addQuranicAchievement.
  ///
  /// In en, this message translates to:
  /// **'Kur’anı-ı Kerim Başarısı Ekle'**
  String get addQuranicAchievement;

  /// No description provided for @editQuranicAchievement.
  ///
  /// In en, this message translates to:
  /// **'Kur’anı-ı Kerim Başarısını Düzenle'**
  String get editQuranicAchievement;

  /// No description provided for @cannotDeleteOffline.
  ///
  /// In en, this message translates to:
  /// **'Bu öğe çevrimdışıyken silinemez.'**
  String get cannotDeleteOffline;

  /// No description provided for @addInterview.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Ekle'**
  String get addInterview;

  /// No description provided for @editInterview.
  ///
  /// In en, this message translates to:
  /// **'Röportajı Düzenle'**
  String get editInterview;

  /// No description provided for @addBookInterview.
  ///
  /// In en, this message translates to:
  /// **'Kitap Röportajı Ekle'**
  String get addBookInterview;

  /// No description provided for @editBookInterview.
  ///
  /// In en, this message translates to:
  /// **'Kitap Röportajını Düzenle'**
  String get editBookInterview;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Not Ekle'**
  String get addNote;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'Veri Yok'**
  String get noDataAvailable;

  /// No description provided for @addTest.
  ///
  /// In en, this message translates to:
  /// **'Test Ekle'**
  String get addTest;

  /// No description provided for @studentGradeInExam.
  ///
  /// In en, this message translates to:
  /// **'Bu sınavdaki öğrenci notu'**
  String get studentGradeInExam;

  /// No description provided for @editTest.
  ///
  /// In en, this message translates to:
  /// **'Testi Düzenle'**
  String get editTest;

  /// No description provided for @teacherOrActivitySupervisor.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen veya Etkinlik Danışmani'**
  String get teacherOrActivitySupervisor;

  /// No description provided for @lessonTeacher.
  ///
  /// In en, this message translates to:
  /// **'Ders Öğretmeni'**
  String get lessonTeacher;

  /// No description provided for @operationCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'İşlem Başarıyla Tamamlandı'**
  String get operationCompletedSuccessfully;

  /// No description provided for @confirmStudentTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bu sınıftan öğrenciyi kaldırarak transfer etmek istediğinizden emin misiniz?'**
  String get confirmStudentTransfer;

  /// No description provided for @confirmStudentDeactivation.
  ///
  /// In en, this message translates to:
  /// **'Öğrenciyi devre dışı bırakmak istediğinizden emin misiniz?'**
  String get confirmStudentDeactivation;

  /// No description provided for @confirmStudentActivation.
  ///
  /// In en, this message translates to:
  /// **'Öğrenciyi aktif hale getirmek istediğinizden emin misiniz?'**
  String get confirmStudentActivation;

  /// No description provided for @addActivity.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik Ekle'**
  String get addActivity;

  /// No description provided for @editActivity.
  ///
  /// In en, this message translates to:
  /// **'Etkinliği Düzenle'**
  String get editActivity;

  /// No description provided for @bookAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Bu kitap zaten mevcut'**
  String get bookAlreadyExists;

  /// No description provided for @mosque.
  ///
  /// In en, this message translates to:
  /// **'Cami'**
  String get mosque;

  /// No description provided for @clickToViewDetails.
  ///
  /// In en, this message translates to:
  /// **'Detayları görmek için tıklayın'**
  String get clickToViewDetails;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Düzenle'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @teacherStatus.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen Durumu'**
  String get teacherStatus;

  /// No description provided for @teacherCenter.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen Merkezi'**
  String get teacherCenter;

  /// No description provided for @teacherClass.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen Sınıfı'**
  String get teacherClass;

  /// No description provided for @currentPlaceOfResidence.
  ///
  /// In en, this message translates to:
  /// **'Mevcut İkamet Yeri'**
  String get currentPlaceOfResidence;

  /// No description provided for @joinedClassOn.
  ///
  /// In en, this message translates to:
  /// **'Bu sınıfa katıldı'**
  String get joinedClassOn;

  /// No description provided for @currentlyTeachingIn.
  ///
  /// In en, this message translates to:
  /// **'Şu anda öğretiyor'**
  String get currentlyTeachingIn;

  /// No description provided for @previousEpisode.
  ///
  /// In en, this message translates to:
  /// **'Önceki Bölüm'**
  String get previousEpisode;

  /// No description provided for @interviewConductedWith.
  ///
  /// In en, this message translates to:
  /// **'Bu röportaj yapıldı'**
  String get interviewConductedWith;

  /// No description provided for @assessment.
  ///
  /// In en, this message translates to:
  /// **'Değerlendirme'**
  String get assessment;

  /// No description provided for @editEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Değerlendirmeyi Düzenle'**
  String get editEvaluation;

  /// No description provided for @evaluatorsName.
  ///
  /// In en, this message translates to:
  /// **'Değerlendirici Adı'**
  String get evaluatorsName;

  /// No description provided for @andTheTime.
  ///
  /// In en, this message translates to:
  /// **'ve zaman'**
  String get andTheTime;

  /// No description provided for @between.
  ///
  /// In en, this message translates to:
  /// **'arasında'**
  String get between;

  /// No description provided for @assessmentConductedOn.
  ///
  /// In en, this message translates to:
  /// **'Bu değerlendirme yapıldı'**
  String get assessmentConductedOn;

  /// No description provided for @totalAssessment.
  ///
  /// In en, this message translates to:
  /// **'Toplam Değerlendirme'**
  String get totalAssessment;

  /// No description provided for @outOf100.
  ///
  /// In en, this message translates to:
  /// **'100 üzerinden'**
  String get outOf100;

  /// No description provided for @addEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Değerlendirme Ekle'**
  String get addEvaluation;

  /// No description provided for @contactSupervisor.
  ///
  /// In en, this message translates to:
  /// **'İletişim'**
  String get contactSupervisor;

  /// No description provided for @usernameAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Kullanıcı adı zaten mevcut'**
  String get usernameAlreadyExists;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'E-posta adresi zaten kullanılıyor'**
  String get emailAlreadyInUse;

  /// No description provided for @idNumberAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Kimlik numarası zaten kullanılıyor'**
  String get idNumberAlreadyInUse;

  /// No description provided for @bookAlreadyAssigned.
  ///
  /// In en, this message translates to:
  /// **'Bu kitap başka bir öğrenciye zaten eklendi ve eklenemez'**
  String get bookAlreadyAssigned;

  /// No description provided for @itemAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Bu öğe zaten mevcut ve tekrar eklenemez'**
  String get itemAlreadyExists;

  /// No description provided for @underDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Geliştirme aşamasında...'**
  String get underDevelopment;

  /// No description provided for @awaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Onay bekleniyor'**
  String get awaitingApproval;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Çıkış yap'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Uygulamadan çıkış yapmak istediğinizden emin misiniz?'**
  String get confirmLogout;

  /// No description provided for @operatedBy.
  ///
  /// In en, this message translates to:
  /// **'Zad Tech tarafından işletiliyor'**
  String get operatedBy;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Uygulama sürümü: 1.3.3'**
  String get appVersion;

  /// No description provided for @evidence.
  ///
  /// In en, this message translates to:
  /// **'Kanıt'**
  String get evidence;

  /// No description provided for @fromTheExhibition.
  ///
  /// In en, this message translates to:
  /// **'Sergiden'**
  String get fromTheExhibition;

  /// No description provided for @fromTheCamera.
  ///
  /// In en, this message translates to:
  /// **'Kameradan'**
  String get fromTheCamera;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Öğe Ekle'**
  String get addItem;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @deactivateStudent.
  ///
  /// In en, this message translates to:
  /// **'Öğrenciyi Devre Dışı Bırak'**
  String get deactivateStudent;

  /// No description provided for @activateStudent.
  ///
  /// In en, this message translates to:
  /// **'Öğrenciyi Aktif Et'**
  String get activateStudent;

  /// No description provided for @authorName.
  ///
  /// In en, this message translates to:
  /// **'Yazar Adı'**
  String get authorName;

  /// No description provided for @addNewItem.
  ///
  /// In en, this message translates to:
  /// **'+ Yeni Öğeyi Ekle'**
  String get addNewItem;

  /// No description provided for @lessonMaterial.
  ///
  /// In en, this message translates to:
  /// **'Ders Materyali'**
  String get lessonMaterial;

  /// No description provided for @lessonDays.
  ///
  /// In en, this message translates to:
  /// **'Ders Günleri'**
  String get lessonDays;

  /// No description provided for @lessonEndDate.
  ///
  /// In en, this message translates to:
  /// **'Ders Bitiş Tarihi'**
  String get lessonEndDate;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'Daha Fazla Seçenek'**
  String get moreOptions;

  /// No description provided for @offlineModeMessage.
  ///
  /// In en, this message translates to:
  /// **'Uygulama çevrimdışı çalışır! Bazı özellikler kullanılamayabilir'**
  String get offlineModeMessage;

  /// No description provided for @quranPagesCount.
  ///
  /// In en, this message translates to:
  /// **'Kur’anı-ı Kerim Sayfa Sayısı'**
  String get quranPagesCount;

  /// No description provided for @mushafPagesCount.
  ///
  /// In en, this message translates to:
  /// **'Mushaf Sayfa Sayısı'**
  String get mushafPagesCount;

  /// No description provided for @pagesConsidering.
  ///
  /// In en, this message translates to:
  /// **'Dikkate Alınan Sayfa Sayısı'**
  String get pagesConsidering;

  /// No description provided for @arabicReadingTestsCount.
  ///
  /// In en, this message translates to:
  /// **'Arapça Okuma Test Sayısı'**
  String get arabicReadingTestsCount;

  /// No description provided for @testsTakenCount.
  ///
  /// In en, this message translates to:
  /// **'Yapılan Test Sayısı'**
  String get testsTakenCount;

  /// No description provided for @testsCount.
  ///
  /// In en, this message translates to:
  /// **'Test Sayısı'**
  String get testsCount;

  /// No description provided for @notesCount.
  ///
  /// In en, this message translates to:
  /// **'Not Sayısı'**
  String get notesCount;

  /// No description provided for @interviewsConductedCount_InterviewsConducted.
  ///
  /// In en, this message translates to:
  /// **'Yapılan Röportaj Sayısı'**
  String get interviewsConductedCount_InterviewsConducted;

  /// No description provided for @lessonsTaughtCount.
  ///
  /// In en, this message translates to:
  /// **'Verilen Ders Sayısı'**
  String get lessonsTaughtCount;

  /// No description provided for @classesGroupsCount.
  ///
  /// In en, this message translates to:
  /// **'Sınıf (Grup) Sayısı'**
  String get classesGroupsCount;

  /// No description provided for @classesCount.
  ///
  /// In en, this message translates to:
  /// **'Sınıf Sayısı'**
  String get classesCount;

  /// No description provided for @lessonsAttendedCount.
  ///
  /// In en, this message translates to:
  /// **'Katılınan Ders Sayısı'**
  String get lessonsAttendedCount;

  /// No description provided for @activitiesImplementedCount.
  ///
  /// In en, this message translates to:
  /// **'Gerçekleştirilen Etkinlik Sayısı'**
  String get activitiesImplementedCount;

  /// No description provided for @activitiesParticipatedCount.
  ///
  /// In en, this message translates to:
  /// **'Katılınan Etkinlik Sayısı'**
  String get activitiesParticipatedCount;

  /// No description provided for @activeStudentsCount.
  ///
  /// In en, this message translates to:
  /// **'Aktif Öğrenci Sayısı'**
  String get activeStudentsCount;

  /// No description provided for @lessonsMissedCount.
  ///
  /// In en, this message translates to:
  /// **'Kaçırılan Ders Sayısı'**
  String get lessonsMissedCount;

  /// No description provided for @personalInterviewsCount.
  ///
  /// In en, this message translates to:
  /// **'Kişisel Röportaj Sayısı'**
  String get personalInterviewsCount;

  /// No description provided for @activitiesNotAttendedCount.
  ///
  /// In en, this message translates to:
  /// **'Katılınmayan Etkinlik Sayısı'**
  String get activitiesNotAttendedCount;

  /// No description provided for @activitiesNotParticipatedCount.
  ///
  /// In en, this message translates to:
  /// **'Katılınmayan Etkinlik Sayısı'**
  String get activitiesNotParticipatedCount;

  /// No description provided for @executedActivitiesCount.
  ///
  /// In en, this message translates to:
  /// **'Yürütülen Etkinlik Sayısı'**
  String get executedActivitiesCount;

  /// No description provided for @attendedActivitiesCount.
  ///
  /// In en, this message translates to:
  /// **'Katılınan Etkinlik Sayısı'**
  String get attendedActivitiesCount;

  /// No description provided for @classesLevelsCount.
  ///
  /// In en, this message translates to:
  /// **'Sınıf (Seviye) Sayısı'**
  String get classesLevelsCount;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Öğrenciler'**
  String get members;

  /// No description provided for @booksReadCount.
  ///
  /// In en, this message translates to:
  /// **'Okunan Kitap Sayısı'**
  String get booksReadCount;

  /// No description provided for @booksDiscussedCount.
  ///
  /// In en, this message translates to:
  /// **'Tartışılan Kitap Sayısı'**
  String get booksDiscussedCount;

  /// No description provided for @arabicReadingPagesCount.
  ///
  /// In en, this message translates to:
  /// **'Arapça Okuma Sayfa Sayısı'**
  String get arabicReadingPagesCount;

  /// No description provided for @memorizedPagesCount.
  ///
  /// In en, this message translates to:
  /// **'Ezberlenen Sayfa Sayısı'**
  String get memorizedPagesCount;

  /// No description provided for @inactiveStudentsCount.
  ///
  /// In en, this message translates to:
  /// **'Aktif Olmayan Öğrenci Sayısı'**
  String get inactiveStudentsCount;

  /// No description provided for @readingsPagesCount.
  ///
  /// In en, this message translates to:
  /// **'Mushaf\'tan Okunan Sayfa Sayısı'**
  String get readingsPagesCount;

  /// No description provided for @readingsCount.
  ///
  /// In en, this message translates to:
  /// **'Okuma Sayısı'**
  String get readingsCount;

  /// No description provided for @interviewsConductedCount.
  ///
  /// In en, this message translates to:
  /// **'Yapılan Röportaj Sayısı'**
  String get interviewsConductedCount;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Sonuçlar'**
  String get results;

  /// No description provided for @fieldNotEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Bu alan boş bırakılamaz'**
  String get fieldNotEmptyError;

  /// No description provided for @mark.
  ///
  /// In en, this message translates to:
  /// **'Not'**
  String get mark;

  /// No description provided for @outOf10.
  ///
  /// In en, this message translates to:
  /// **'10 üzerinden'**
  String get outOf10;

  /// No description provided for @validPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Lütfen geçerli bir telefon numarası girin'**
  String get validPhoneNumber;

  /// No description provided for @searchForCountry.
  ///
  /// In en, this message translates to:
  /// **'İstenilen Ülkeyi Ara'**
  String get searchForCountry;

  /// No description provided for @validEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Lütfen geçerli bir e-posta adresi girin'**
  String get validEmailAddress;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Açıklama'**
  String get description;

  /// No description provided for @levels.
  ///
  /// In en, this message translates to:
  /// **'Seviyeler'**
  String get levels;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Öğrenciler'**
  String get students;

  /// No description provided for @teachers.
  ///
  /// In en, this message translates to:
  /// **'Öğretmenler'**
  String get teachers;

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Sınıflar'**
  String get classes;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Bilgi'**
  String get information;

  /// No description provided for @interviews.
  ///
  /// In en, this message translates to:
  /// **'Rehberlik'**
  String get interviews;

  /// No description provided for @lessonsMissed.
  ///
  /// In en, this message translates to:
  /// **'Devamsızlık'**
  String get lessonsMissed;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Etkinlikler'**
  String get events;

  /// No description provided for @eventsMissed.
  ///
  /// In en, this message translates to:
  /// **'Kaçırılan Etkinlikler'**
  String get eventsMissed;

  /// No description provided for @exams.
  ///
  /// In en, this message translates to:
  /// **'Sınavlar'**
  String get exams;

  /// No description provided for @teacherClasses.
  ///
  /// In en, this message translates to:
  /// **'Öğretmenin Sınıfları'**
  String get teacherClasses;

  /// No description provided for @evaluations.
  ///
  /// In en, this message translates to:
  /// **'Değerlendirmeler'**
  String get evaluations;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Değerlendirme'**
  String get ratings;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get schedule;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Mükemmel'**
  String get excellent;

  /// No description provided for @veryGood.
  ///
  /// In en, this message translates to:
  /// **'Çok İyi'**
  String get veryGood;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'İyi'**
  String get good;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Orta'**
  String get average;

  /// No description provided for @fail.
  ///
  /// In en, this message translates to:
  /// **'Başarısız'**
  String get fail;

  /// No description provided for @regionName.
  ///
  /// In en, this message translates to:
  /// **'Bölge Adı'**
  String get regionName;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Tür'**
  String get type;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Telefon Numarası'**
  String get phoneNumber;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @schoolLocationDescription.
  ///
  /// In en, this message translates to:
  /// **'Okulun Yerinin Açıklaması'**
  String get schoolLocationDescription;

  /// No description provided for @branchPhoto.
  ///
  /// In en, this message translates to:
  /// **'Şube Fotoğrafı'**
  String get branchPhoto;

  /// No description provided for @addGeneralStudentInformation.
  ///
  /// In en, this message translates to:
  /// **'Genel Öğrenci Bilgisi Ekle'**
  String get addGeneralStudentInformation;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get first_name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Soyad'**
  String get surname;

  /// No description provided for @studentPhoto.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci Fotoğrafı'**
  String get studentPhoto;

  /// No description provided for @certificatePhotos.
  ///
  /// In en, this message translates to:
  /// **'Sertifika Fotoğrafları'**
  String get certificatePhotos;

  /// No description provided for @addPrivateStudentInformation.
  ///
  /// In en, this message translates to:
  /// **'Özel Öğrenci Bilgisi Ekle'**
  String get addPrivateStudentInformation;

  /// No description provided for @chronicIllnessName.
  ///
  /// In en, this message translates to:
  /// **'Kronik Hastalık Adı'**
  String get chronicIllnessName;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'Önceki soruya cevap evet ise, lütfen hastalığın adını yazın'**
  String get treatment;

  /// No description provided for @orphan.
  ///
  /// In en, this message translates to:
  /// **'Yetim'**
  String get orphan;

  /// No description provided for @addGeneralTeacherInformation.
  ///
  /// In en, this message translates to:
  /// **'Genel Öğretmen Bilgisi Ekle'**
  String get addGeneralTeacherInformation;

  /// No description provided for @teacherPhoto.
  ///
  /// In en, this message translates to:
  /// **'Öğretmen Fotoğrafı'**
  String get teacherPhoto;

  /// No description provided for @addPrivateTeacherInformation.
  ///
  /// In en, this message translates to:
  /// **'Özel Öğretmen Bilgisi Ekle'**
  String get addPrivateTeacherInformation;

  /// No description provided for @wivesCount.
  ///
  /// In en, this message translates to:
  /// **'Evli ise eş sayısı'**
  String get wivesCount;

  /// No description provided for @householdChronicIllness.
  ///
  /// In en, this message translates to:
  /// **'Evde Kronik Hastalık'**
  String get householdChronicIllness;

  /// No description provided for @subjectName.
  ///
  /// In en, this message translates to:
  /// **'Konu Adı'**
  String get subjectName;

  /// No description provided for @subjectDescription.
  ///
  /// In en, this message translates to:
  /// **'Konu Açıklaması'**
  String get subjectDescription;

  /// No description provided for @bookType.
  ///
  /// In en, this message translates to:
  /// **'Kitap Türü'**
  String get bookType;

  /// No description provided for @bookCover.
  ///
  /// In en, this message translates to:
  /// **'Kitap Kapağı'**
  String get bookCover;

  /// No description provided for @activityTypeName.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik Türü Adı'**
  String get activityTypeName;

  /// No description provided for @activityTypeDescription.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik Türü Açıklaması'**
  String get activityTypeDescription;

  /// No description provided for @activityTypeGoal.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik Türü Hedefi'**
  String get activityTypeGoal;

  /// No description provided for @activityLocation.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik Yeri'**
  String get activityLocation;

  /// No description provided for @activityPhoto.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik Fotoğrafı'**
  String get activityPhoto;

  /// No description provided for @weeklyEducationalReport.
  ///
  /// In en, this message translates to:
  /// **'Haftalık Eğitim Raporu'**
  String get weeklyEducationalReport;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Yer'**
  String get place;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Başlangıç Tarihi'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'Bitiş Tarihi'**
  String get endDate;

  /// No description provided for @responsiblePerson.
  ///
  /// In en, this message translates to:
  /// **'Sorumlu Kişi'**
  String get responsiblePerson;

  /// No description provided for @educationalTopics.
  ///
  /// In en, this message translates to:
  /// **'Eğitim Konuları'**
  String get educationalTopics;

  /// No description provided for @teacherRelatedTopics.
  ///
  /// In en, this message translates to:
  /// **'Öğretmenle İlgili Konular'**
  String get teacherRelatedTopics;

  /// No description provided for @curriculumRelatedTopics.
  ///
  /// In en, this message translates to:
  /// **'Müfredatla İlgili Konular'**
  String get curriculumRelatedTopics;

  /// No description provided for @studentRelatedTopics.
  ///
  /// In en, this message translates to:
  /// **'Öğrenciyle İlgili Konular'**
  String get studentRelatedTopics;

  /// No description provided for @activityAndEventTopics.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik ve Olay Konuları'**
  String get activityAndEventTopics;

  /// No description provided for @guestsAndOfficialFiguresTopics.
  ///
  /// In en, this message translates to:
  /// **'Misafirler ve Resmi Kişiler Konuları'**
  String get guestsAndOfficialFiguresTopics;

  /// No description provided for @needsAndLogistics.
  ///
  /// In en, this message translates to:
  /// **'İhtiyaçlar ve Lojistik'**
  String get needsAndLogistics;

  /// No description provided for @postponedTopics.
  ///
  /// In en, this message translates to:
  /// **'Ertelenen Konular'**
  String get postponedTopics;

  /// No description provided for @reportImage.
  ///
  /// In en, this message translates to:
  /// **'Rapor Görüntüsü'**
  String get reportImage;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Kapasite'**
  String get capacity;

  /// No description provided for @sectionPhoto.
  ///
  /// In en, this message translates to:
  /// **'Bölüm Fotoğrafı'**
  String get sectionPhoto;

  /// No description provided for @lessonDuration.
  ///
  /// In en, this message translates to:
  /// **'Ders Süresi'**
  String get lessonDuration;

  /// No description provided for @interviewReason.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Nedeni'**
  String get interviewReason;

  /// No description provided for @interviewPlace.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Yeri'**
  String get interviewPlace;

  /// No description provided for @interviewTime.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Saati'**
  String get interviewTime;

  /// No description provided for @interviewResult.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Sonucu'**
  String get interviewResult;

  /// No description provided for @bookSummary.
  ///
  /// In en, this message translates to:
  /// **'Kitap Özeti'**
  String get bookSummary;

  /// No description provided for @summaryImage.
  ///
  /// In en, this message translates to:
  /// **'Özet Görüntüsü'**
  String get summaryImage;

  /// No description provided for @pedagogical.
  ///
  /// In en, this message translates to:
  /// **'Pedagojik'**
  String get pedagogical;

  /// No description provided for @interviewGrade.
  ///
  /// In en, this message translates to:
  /// **'Röportaj Notu'**
  String get interviewGrade;

  /// No description provided for @testName.
  ///
  /// In en, this message translates to:
  /// **'Test Adı'**
  String get testName;

  /// No description provided for @curriculum.
  ///
  /// In en, this message translates to:
  /// **'Müfredat'**
  String get curriculum;

  /// No description provided for @testGrade.
  ///
  /// In en, this message translates to:
  /// **'Test Notu'**
  String get testGrade;

  /// No description provided for @correctArabicReading.
  ///
  /// In en, this message translates to:
  /// **'Doğru Arapça Okuma'**
  String get correctArabicReading;

  /// No description provided for @recitationDate.
  ///
  /// In en, this message translates to:
  /// **'Okuma Tarihi'**
  String get recitationDate;

  /// No description provided for @recitationFromQuran.
  ///
  /// In en, this message translates to:
  /// **'Kur\'an\'dan Okuma'**
  String get recitationFromQuran;

  /// No description provided for @memorization.
  ///
  /// In en, this message translates to:
  /// **'Ezberleme'**
  String get memorization;

  /// No description provided for @recitationType.
  ///
  /// In en, this message translates to:
  /// **'Okuma Türü'**
  String get recitationType;

  /// No description provided for @recitationGrade.
  ///
  /// In en, this message translates to:
  /// **'Okuma Notu'**
  String get recitationGrade;

  /// No description provided for @observationDate.
  ///
  /// In en, this message translates to:
  /// **'Gözlem Tarihi'**
  String get observationDate;

  /// No description provided for @observationTime.
  ///
  /// In en, this message translates to:
  /// **'Gözlem Saati'**
  String get observationTime;

  /// No description provided for @teachersEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Öğretmenlerin Değerlendirmesi'**
  String get teachersEvaluation;

  /// No description provided for @observer.
  ///
  /// In en, this message translates to:
  /// **'Gözlemci'**
  String get observer;

  /// No description provided for @arabicReadingGradeOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Arabça okuma dersi değerlendirme 10 üzerinden'**
  String get arabicReadingGradeOutOf10;

  /// No description provided for @recitationTeachingGradeOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Yüzüne Dersi değerlendirme 10 üzerinden'**
  String get recitationTeachingGradeOutOf10;

  /// No description provided for @scientificLessonGradeOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Temel dini bilgiler değerlendirme 10 üzerinden'**
  String get scientificLessonGradeOutOf10;

  /// No description provided for @individualFollowUpTimeGradeOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Ezber dersi değerlendirme 10 üzerinden'**
  String get individualFollowUpTimeGradeOutOf10;

  /// No description provided for @circleManagement.
  ///
  /// In en, this message translates to:
  /// **'Grup Değerlendirmesi'**
  String get circleManagement;

  /// No description provided for @planCommitmentGradeOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Yıllık plana riayet etmes 10 üzerinden'**
  String get planCommitmentGradeOutOf10;

  /// No description provided for @punctualityGradeOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Dakiklik Notu 10 üzerinden'**
  String get punctualityGradeOutOf10;

  /// No description provided for @studentDisciplineGradeOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci Disiplini Notu 10 üzerinden'**
  String get studentDisciplineGradeOutOf10;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik'**
  String get activity;

  /// No description provided for @activitiesGradeOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Etkinlikler Notu 10 üzerinden'**
  String get activitiesGradeOutOf10;

  /// No description provided for @administrativeDisciplineGradeOutOf10.
  ///
  /// In en, this message translates to:
  /// **'Yönetmeliklere riayeti Notu 10 üzerinden'**
  String get administrativeDisciplineGradeOutOf10;

  /// No description provided for @studentsAttendingCount.
  ///
  /// In en, this message translates to:
  /// **'Katılan Öğrenci Sayısı'**
  String get studentsAttendingCount;

  /// No description provided for @lessonplace.
  ///
  /// In en, this message translates to:
  /// **'Ders Yeri'**
  String get lessonplace;

  /// No description provided for @testandstudies.
  ///
  /// In en, this message translates to:
  /// **'Testler ve Çalışmalar 10 üzerinden notlandırılır'**
  String get testandstudies;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @edit_book.
  ///
  /// In en, this message translates to:
  /// **'Kitabı Düzenle'**
  String get edit_book;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Notu Düzenle'**
  String get editNote;

  /// No description provided for @addEpisode.
  ///
  /// In en, this message translates to:
  /// **'Bölüm Ekle'**
  String get addEpisode;

  /// No description provided for @addEpisodeOrDivision.
  ///
  /// In en, this message translates to:
  /// **'Bölüm veya Bölüm Ekle'**
  String get addEpisodeOrDivision;

  /// No description provided for @addDivision.
  ///
  /// In en, this message translates to:
  /// **'Bölüm Ekle'**
  String get addDivision;

  /// No description provided for @editEpisodeOrDivision.
  ///
  /// In en, this message translates to:
  /// **'Bölüm veya Bölümü Düzenle'**
  String get editEpisodeOrDivision;

  /// No description provided for @editEpisode.
  ///
  /// In en, this message translates to:
  /// **'Bölümü Düzenle'**
  String get editEpisode;

  /// No description provided for @editDivision.
  ///
  /// In en, this message translates to:
  /// **'Bölümü Düzenle'**
  String get editDivision;

  /// No description provided for @numberOfActivities.
  ///
  /// In en, this message translates to:
  /// **'Etkinlik Sayısı'**
  String get numberOfActivities;

  /// No description provided for @numberOfLessons.
  ///
  /// In en, this message translates to:
  /// **'Ders Sayısı'**
  String get numberOfLessons;

  /// No description provided for @numberOfStudents.
  ///
  /// In en, this message translates to:
  /// **'Öğrenci Sayısı'**
  String get numberOfStudents;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'itibaren'**
  String get from;

  /// No description provided for @accountInactive_tr.
  ///
  /// In en, this message translates to:
  /// **'Hesabınız aktif değil'**
  String get accountInactive_tr;

  /// No description provided for @accountPending_tr.
  ///
  /// In en, this message translates to:
  /// **'Hesabınız beklemede'**
  String get accountPending_tr;

  /// No description provided for @yourAccountDisabledOrApprovalStage.
  ///
  /// In en, this message translates to:
  /// **'Hesabınız devre dışı bırakıldı veya onay aşamasında. Lütfen uygulama yöneticisine başvurun.'**
  String get yourAccountDisabledOrApprovalStage;

  /// No description provided for @usernameRestriction.
  ///
  /// In en, this message translates to:
  /// **'Kullanıcı adı yalnızca harf (a-z, A-Z) ve rakam içerebilir'**
  String get usernameRestriction;

  /// No description provided for @downloadTheApp.
  ///
  /// In en, this message translates to:
  /// **'Güncellemeyi indir'**
  String get downloadTheApp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
