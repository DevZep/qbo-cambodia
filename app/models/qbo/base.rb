class Qbo::Base
  attr_reader :credential
  attr_reader :record

  NUMBER_EN_KM = {
    '1' => '១',
    '2' => '២',
    '3' => '៣',
    '4' => '៤',
    '5' => '៥',
    '6' => '៦',
    '7' => '៧',
    '8' => '៨',
    '9' => '៩',
    '0' => '០'
  }

  MONTH_EN_KM = {
    '1' => 'មករា',
    '2' => 'កុម្ភះ',
    '3' => 'មិនា',
    '4' => 'មេសា',
    '5' => 'ឧសភា',
    '6' => 'មិថុនា',
    '7' => 'កក្តដា',
    '8' => 'សីហា',
    '9' => 'កញ្ញា',
    '10' => 'តុលា',
    '11' => 'វិច្ឆិកា',
    '12' => 'ធ្នូ'
  }

  def service
    service_class.new(access_token: auth, realm_id: credential.company_id)
  end

  def method_missing(method, *args)
    record.send(method, *args)
  end

  private

  def auth
    OAuth::AccessToken.new(QB_OAUTH_CONSUMER, credential.access_token, credential.access_secret)
  end

  def service_class

  end
end
