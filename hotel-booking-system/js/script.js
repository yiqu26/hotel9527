document.addEventListener('DOMContentLoaded', function() {
    // 漢堡選單功能
    const hamburger = document.querySelector('.hamburger');
    const navLinks = document.querySelector('.nav-links');

    if (hamburger) {
        hamburger.addEventListener('click', function() {
            navLinks.classList.toggle('active');
        });
    }

    // 登入彈窗
    const loginBtn = document.getElementById('login-btn');
    const loginModal = document.getElementById('login-modal');
    
    if (loginBtn && loginModal) {
        loginBtn.addEventListener('click', function(e) {
            e.preventDefault();
            loginModal.style.display = 'flex';
        });
    }

    // 註冊彈窗
    const registerBtn = document.getElementById('register-btn');
    const registerModal = document.getElementById('register-modal');
    
    if (registerBtn && registerModal) {
        registerBtn.addEventListener('click', function(e) {
            e.preventDefault();
            registerModal.style.display = 'flex';
        });
    }

    // 關閉彈窗
    const closeBtns = document.querySelectorAll('.close');
    
    closeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            const modal = this.closest('.modal');
            if (modal) {
                modal.style.display = 'none';
            }
        });
    });

    // 點擊彈窗外部關閉彈窗
    window.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal')) {
            e.target.style.display = 'none';
        }
    });

    // 預約表單功能
    const bookingForm = document.getElementById('booking-form');
    
    if (bookingForm) {
        // 初始化表單
        const roomTypeSelect = document.getElementById('room-type');
        const guestsSelect = document.getElementById('guests');
        const checkInInput = document.getElementById('check-in');
        const checkOutInput = document.getElementById('check-out');

        // 設置最小日期為今天
        const today = new Date();
        const dd = String(today.getDate()).padStart(2, '0');
        const mm = String(today.getMonth() + 1).padStart(2, '0');
        const yyyy = today.getFullYear();
        const todayStr = yyyy + '-' + mm + '-' + dd;
        
        if (checkInInput) {
            checkInInput.min = todayStr;
            
            // 入住日期變更時，設置退房日期最小值
            checkInInput.addEventListener('change', function() {
                if (checkOutInput) {
                    checkOutInput.min = this.value;
                    // 如果退房日期早於入住日期，則將退房日期設為入住日期
                    if (checkOutInput.value && checkOutInput.value < this.value) {
                        checkOutInput.value = this.value;
                    }
                    updateSummary();
                }
            });
        }

        if (checkOutInput) {
            checkOutInput.min = todayStr;
            checkOutInput.addEventListener('change', updateSummary);
        }

        if (roomTypeSelect) {
            roomTypeSelect.addEventListener('change', function() {
                updateSummary();
                updateMaxGuests();
            });
        }

        if (guestsSelect) {
            guestsSelect.addEventListener('change', updateSummary);
        }

        // 更新摘要區域
        function updateSummary() {
            const summaryRoomType = document.getElementById('summary-room-type');
            const summaryCheckIn = document.getElementById('summary-check-in');
            const summaryCheckOut = document.getElementById('summary-check-out');
            const summaryNights = document.getElementById('summary-nights');
            const summaryGuests = document.getElementById('summary-guests');
            const summaryPricePerNight = document.getElementById('summary-price-per-night');
            const summaryTotal = document.getElementById('summary-total');
            const summaryImage = document.getElementById('summary-image');

            if (!roomTypeSelect || !checkInInput || !checkOutInput || !guestsSelect) {
                return;
            }

            // 獲取房型文字
            let roomTypeText = '';
            let pricePerNight = 0;
            let roomImage = '';

            switch (roomTypeSelect.value) {
                case 'single':
                    roomTypeText = '單人精緻房';
                    pricePerNight = 1800;
                    roomImage = 'https://images.unsplash.com/photo-1611892440504-42a792e24d32';
                    break;
                case 'double':
                    roomTypeText = '豪華雙人房';
                    pricePerNight = 2500;
                    roomImage = 'https://images.unsplash.com/photo-1590490360182-c33d57733427';
                    break;
                case 'family':
                    roomTypeText = '家庭套房';
                    pricePerNight = 3800;
                    roomImage = 'https://images.unsplash.com/photo-1566665797739-1674de7a421a';
                    break;
                case 'suite':
                    roomTypeText = '豪華套房';
                    pricePerNight = 5800;
                    roomImage = 'https://images.unsplash.com/photo-1578683010236-d716f9a3f461';
                    break;
                default:
                    roomTypeText = '-';
                    pricePerNight = 0;
                    roomImage = 'https://images.unsplash.com/photo-1566665797739-1674de7a421a';
            }

            // 計算住宿天數
            let nights = 0;
            if (checkInInput.value && checkOutInput.value) {
                const checkInDate = new Date(checkInInput.value);
                const checkOutDate = new Date(checkOutInput.value);
                const timeDiff = checkOutDate.getTime() - checkInDate.getTime();
                nights = Math.ceil(timeDiff / (1000 * 3600 * 24));
            }

            // 計算總價
            const total = pricePerNight * nights;

            // 更新顯示
            if (summaryRoomType) summaryRoomType.textContent = roomTypeText;
            if (summaryCheckIn) summaryCheckIn.textContent = checkInInput.value ? formatDate(checkInInput.value) : '-';
            if (summaryCheckOut) summaryCheckOut.textContent = checkOutInput.value ? formatDate(checkOutInput.value) : '-';
            if (summaryNights) summaryNights.textContent = nights > 0 ? nights + '晚' : '-';
            if (summaryGuests) summaryGuests.textContent = guestsSelect.value + '人';
            if (summaryPricePerNight) summaryPricePerNight.textContent = pricePerNight > 0 ? 'NT$ ' + pricePerNight : '-';
            if (summaryTotal) summaryTotal.textContent = total > 0 ? 'NT$ ' + total : '-';
            
            // 更新房間圖片
            if (summaryImage && roomImage) {
                const img = summaryImage.querySelector('img');
                if (img) {
                    img.src = roomImage;
                    img.alt = roomTypeText;
                }
            }
        }

        // 根據房型更新人數選項
        function updateMaxGuests() {
            if (!roomTypeSelect || !guestsSelect) {
                return;
            }

            // 獲取最大人數
            let maxGuests = 1;
            switch (roomTypeSelect.value) {
                case 'single':
                    maxGuests = 1;
                    break;
                case 'double':
                    maxGuests = 2;
                    break;
                case 'family':
                    maxGuests = 4;
                    break;
                case 'suite':
                    maxGuests = 2;
                    break;
            }

            // 重建人數選項
            guestsSelect.innerHTML = '';
            for (let i = 1; i <= maxGuests; i++) {
                const option = document.createElement('option');
                option.value = i;
                option.textContent = i + '人';
                guestsSelect.appendChild(option);
            }
        }

        // 格式化日期為本地格式
        function formatDate(dateStr) {
            const date = new Date(dateStr);
            return date.toLocaleDateString('zh-TW');
        }

        // 表單提交
        bookingForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            alert('預約提交成功！\n我們將盡快處理您的預約請求。');
            
            // 在實際應用中，這裡會使用AJAX發送數據到服務器
            // 這裡僅作為示範
        });

        // URL 參數處理，從客房頁面傳遞的預選房型
        const params = new URLSearchParams(window.location.search);
        const roomParam = params.get('room');
        
        if (roomParam && roomTypeSelect) {
            roomTypeSelect.value = roomParam;
            updateMaxGuests();
            updateSummary();
        }
    }

    // 房間頁面的搜索表單
    const filterForm = document.getElementById('filter-form');
    
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 在實際應用中，這會是一個AJAX請求來過濾房間
            alert('搜索功能已觸發');
        });
    }

    // 登入表單和註冊表單功能
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');
    
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 在實際應用中，這會是一個AJAX請求來驗證用戶
            alert('登入功能已觸發');
            const loginModal = document.getElementById('login-modal');
            if (loginModal) {
                loginModal.style.display = 'none';
            }
        });
    }
    
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 在實際應用中，這會是一個AJAX請求來註冊用戶
            alert('註冊功能已觸發');
            const registerModal = document.getElementById('register-modal');
            if (registerModal) {
                registerModal.style.display = 'none';
            }
        });
    }
}); 