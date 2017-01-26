
feature "Customer show page" , type: :feature do
  given!(:user) {create(:user,email:'cail.cl29@gmail.com',password:'raizer')}

  background do 
    save_and_open_screenshot '1.jpg'
    login_as(user)
    # binding.pry
    # puts current_url
  end

  it "display customer's detail", js:true do
    save_and_open_screenshot '2.jpg'
    sleep 10
    visit companies_path
    save_and_open_screenshot '3.jpg'

    # fill_in('user_email', with: 'cail.cl29@gmail.com')
    # save_and_open_screenshot '1.jpg'
    # fill_in('user_password', with: 'raizer')
    # save_and_open_screenshot '2.jpg'
    # click_button 'Sign in'
    # save_and_open_screenshot '3.jpg'
    # sleep 30
    binding.pry
    # save_and_open_screenshot '3.jpg'
    page.execute_script('$("#qboimg").trigger("click")')
    find('#qboimg').trigger('click')
    main = page.driver.browser.window_handles.first
    popup = page.driver.browser.window_handles.last
    page.driver.browser.switch_to_window(popup)
    # expect(page).to have_link('Sandbox Company_US_2')

  end
end