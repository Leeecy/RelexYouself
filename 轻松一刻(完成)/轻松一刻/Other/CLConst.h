
#import <UIKit/UIKit.h>
typedef enum {
    CLTopicTypeAll = 1,
    CLTopicTypePicture = 10,
    CLTopicTypeWord = 29,
    CLTopicTypeVoice = 31,
    CLTopicTypeVideo = 41
} CLTopicType;
/** 精华-顶部标题的高度 */
UIKIT_EXTERN CGFloat const CLTitilesViewH;
/** 精华-顶部标题的Y */
UIKIT_EXTERN CGFloat const CLTitilesViewY;

/** 精华-cell-间距 */
UIKIT_EXTERN CGFloat const CLTopicCellMargin;
/** 精华-cell-文字内容的Y值 */
UIKIT_EXTERN CGFloat const CLTopicCellTextY;
/** 精华-cell-底部工具条的高度 */
UIKIT_EXTERN CGFloat const CLTopicCellBottomBarH;
/** 精华-cell-图片帖子的最大高度 */
UIKIT_EXTERN  CGFloat const CLTopicCellPictureMaxH ;
/** 精华-cell-图片帖子一旦超过最大高度,就是用Break */
UIKIT_EXTERN  CGFloat const CLTopicCellPictureBreakH;
/** XMGUser模型-性别属性值 */
UIKIT_EXTERN NSString * const CLUserSexMale ;
UIKIT_EXTERN NSString * const CLUserSexFemale ;

/** 精华-cell-最热评论标题的高度 */
UIKIT_EXTERN CGFloat const CLTopicCellTopCmtTitleH;
/** tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const CLTabBarDidSelectNotification;
/** tabBar被选中的通知 - 被选中的控制器的index key */
UIKIT_EXTERN NSString * const CLSelectedControllerIndexKey;
/** tabBar被选中的通知 - 被选中的控制器 key */
UIKIT_EXTERN NSString * const CLSelectedControllerKey ;