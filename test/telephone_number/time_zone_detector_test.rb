require "test_helper"

module TelephoneNumber
  class TimeZoneDetectorTest < Minitest::Test
    def test_returns_correct_timezone
      assert_equal 'Asia/Dubai', TelephoneNumber.parse('+971529933171').timezone
      assert_equal 'America/Buenos_Aires', TelephoneNumber.parse('+5491112345678').timezone
      assert_equal 'Antarctica/Macquarie, Australia/Adelaide, Australia/Eucla, Australia/Lord_Howe, Australia/Perth, Australia/Sydney, Indian/Christmas, Indian/Cocos', TelephoneNumber.parse(+61467703037).timezone
      assert_equal 'Europe/Brussels', TelephoneNumber.parse('+32498485960').timezone
      assert_equal 'America/La_Paz', TelephoneNumber.parse('+59178500348').timezone
      assert_equal 'America/Sao_Paulo', TelephoneNumber.parse('+5511992339376').timezone
      assert_equal 'Europe/Moscow', TelephoneNumber.parse('+375152450911').timezone
      assert_equal 'America/Toronto', TelephoneNumber.parse('+16135550119').timezone
      assert_equal 'Europe/Zurich', TelephoneNumber.parse('+41794173875').timezone
      assert_equal 'America/Santiago', TelephoneNumber.parse('+56961234567').timezone
      assert_equal 'Asia/Shanghai', TelephoneNumber.parse('+8615694876068').timezone
      assert_equal 'America/Bogota', TelephoneNumber.parse('+573211234567').timezone
      assert_equal 'America/Costa_Rica', TelephoneNumber.parse('+50622123456').timezone
      assert_equal 'Europe/Berlin', TelephoneNumber.parse('+4915222503070').timezone
      assert_equal 'Europe/Copenhagen', TelephoneNumber.parse('+4524453744').timezone
      assert_equal 'America/Guayaquil, Pacific/Galapagos', TelephoneNumber.parse('+593992441504').timezone
      assert_equal 'Europe/Bucharest', TelephoneNumber.parse('+37253629280').timezone
      assert_equal 'Atlantic/Canary, Europe/Madrid', TelephoneNumber.parse('+34606217800').timezone
      assert_equal 'Europe/Paris', TelephoneNumber.parse('+33607114556').timezone
      assert_equal 'Europe/London', TelephoneNumber.parse('+448444156790').timezone
      assert_equal 'Asia/Hong_Kong', TelephoneNumber.parse('+85264636251').timezone
      assert_equal 'Europe/Budapest', TelephoneNumber.parse('+36709311285').timezone
      assert_equal 'Europe/Dublin', TelephoneNumber.parse('+353863634875').timezone
      assert_equal 'Asia/Calcutta', TelephoneNumber.parse('+915622231515').timezone
      assert_equal 'Europe/Rome, Europe/Vatican', TelephoneNumber.parse('+393478258998').timezone
      assert_equal 'Asia/Tokyo', TelephoneNumber.parse('+81312345678').timezone
      assert_equal 'Asia/Seoul', TelephoneNumber.parse('+821036424812').timezone
      assert_equal 'America/Mexico_City', TelephoneNumber.parse('+524423593227').timezone
      assert_equal 'Europe/Amsterdam', TelephoneNumber.parse('+31610958780').timezone
      assert_equal 'Europe/Oslo', TelephoneNumber.parse('+4792272668').timezone
      assert_equal 'Pacific/Auckland, Pacific/Chatham', TelephoneNumber.parse('+64212715077').timezone
      assert_equal 'America/Lima', TelephoneNumber.parse('+51994156035').timezone
      assert_equal 'Asia/Manila', TelephoneNumber.parse('+639285588185').timezone
      assert_equal 'Europe/Warsaw', TelephoneNumber.parse('+48665666003').timezone
      assert_equal 'Asia/Qatar', TelephoneNumber.parse('+97470482288').timezone
      assert_equal 'Europe/Bucharest', TelephoneNumber.parse('+40724242563').timezone
      assert_equal 'Asia/Riyadh', TelephoneNumber.parse('+966503891468').timezone
      assert_equal 'Europe/Stockholm', TelephoneNumber.parse('+46708922920').timezone
      assert_equal 'Asia/Singapore', TelephoneNumber.parse('+6596924755').timezone
      assert_equal 'Europe/Istanbul', TelephoneNumber.parse('+905497728782').timezone
      assert_equal 'America/Port_of_Spain', TelephoneNumber.parse('+18687804765').timezone
      assert_equal 'Asia/Taipei', TelephoneNumber.parse('+886905627933').timezone
      assert_equal 'America/Los_Angeles', TelephoneNumber.parse('+16502530000').timezone
      assert_equal 'America/Caracas', TelephoneNumber.parse('+584149993108').timezone
      assert_equal 'Africa/Johannesburg', TelephoneNumber.parse('+27826187617').timezone
    end
  end
end
